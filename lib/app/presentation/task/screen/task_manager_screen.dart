import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/task_entity.dart';
import 'package:optima_sync_v2/app/presentation/project/widgets/project_widgets.dart';
import 'package:optima_sync_v2/app/presentation/task/bloc/task_bloc.dart';
import 'package:optima_sync_v2/app/presentation/task/bloc/task_event.dart';
import 'package:optima_sync_v2/app/presentation/task/bloc/task_state.dart';
import 'package:optima_sync_v2/app/presentation/task/pages/task_filter_sheet.dart';
import 'package:optima_sync_v2/app/presentation/task/pages/task_form_dialog.dart';
import 'package:optima_sync_v2/app/presentation/task/screen/task_categories_screen.dart';
import 'package:optima_sync_v2/app/presentation/task/screen/task_details_screen.dart';
import 'package:optima_sync_v2/app/presentation/task/widgets/task_widgets.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';
import 'package:optima_sync_v2/core/widgets/app_drawer.dart';

class TaskManagerScreen extends StatefulWidget {
  const TaskManagerScreen({super.key});
  @override
  State<TaskManagerScreen> createState() => _TaskManagerScreenState();
}

class _TaskManagerScreenState extends State<TaskManagerScreen> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(const LoadTasks(filter: TaskFilter()));
  }

  @override
  void dispose() { _search.dispose(); super.dispose(); }

  Future<void> _refresh() async {
    final bloc = context.read<TaskBloc>();
    if (bloc.state is TaskLoading || bloc.state is TaskWorking) return;
    if (!bloc.usecases.isConfigured) return;
    final done = bloc.stream.firstWhere((state) =>
        state is TaskLoaded || state is TaskFailure || state is TaskUnavailable);
    bloc.add(const LoadTasks());
    await done;
  }

  void _openForm([TaskEntity? task]) => showDialog<void>(
    context: context, barrierDismissible: false,
    builder: (_) => BlocProvider.value(value: context.read<TaskBloc>(), child: TaskFormDialog(task: task)),
  );

  Future<void> _filters(TaskManagerData data) async {
    final filter = await showModalBottomSheet<TaskFilter>(
      context: context, isScrollControlled: true, useSafeArea: true,
      backgroundColor: AppPallete.cardBackground,
      builder: (_) => TaskFilterSheet(data: data),
    );
    if (filter != null && mounted) context.read<TaskBloc>().add(LoadTasks(filter: filter));
  }

  Future<void> _delete(TaskEntity task) async {
    final confirmed = await confirmTaskRemoval(context, 'Delete task?', 'Delete "${task.title}"?');
    if (confirmed && mounted) context.read<TaskBloc>().add(DeleteTaskSubmitted(task.id));
  }

  void _details(TaskEntity task) => Navigator.push(context,
    MaterialPageRoute(builder: (_) => BlocProvider.value(
      value: context.read<TaskBloc>(), child: TaskDetailsScreen(taskId: task.id))));

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppPallete.pageBackground,
    drawer: const AppDrawer(selectedItem: 'Task Manager'),
    appBar: AppBar(
      backgroundColor: AppPallete.cardBackground,
      surfaceTintColor: AppPallete.cardBackground,
      title: const Text('Task Manager', style: TextStyle(fontWeight: FontWeight.w800)),
    ),
    body: BlocConsumer<TaskBloc, TaskState>(
      listener: (context, state) {
        if (ModalRoute.of(context)?.isCurrent != true) return;
        final message = state is TaskLoaded ? state.message
            : state is TaskFailure && state.data != null ? state.message : null;
        if (message != null) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      },
      builder: (context, state) {
        final data = state.data;
        final busy = state is TaskLoading || state is TaskWorking;
        final tasks = data == null ? <TaskEntity>[] : data.visibleTasks.where((task) => [
          task.title, task.description, _taskCategory(data, task), _taskMember(data, task),
          task.status, task.priority, task.assignedBy,
        ].any((value) => value.toLowerCase().contains(_query))).toList();
        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
            children: [
              TaskSurface(child: LayoutBuilder(builder: (context, constraints) {
                final heading = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Task Manager', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppPallete.textPrimary)),
                  const SizedBox(height: 6),
                  Text(data == null ? 'Organize tasks, assignments and due dates.'
                      : data.access.isManager ? 'Manage tasks across your team.' : 'Keep track of the tasks assigned to you.',
                    style: const TextStyle(color: AppPallete.textSecondary, fontSize: 12.5)),
                ]);
                final actions = Wrap(spacing: 8, runSpacing: 8, children: [
                  OutlinedButton.icon(
                    onPressed: data == null || busy ? null : () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => BlocProvider.value(
                          value: context.read<TaskBloc>(), child: const TaskCategoriesScreen()))),
                    icon: const Icon(Icons.category_outlined, size: 18), label: const Text('Categories'),
                  ),
                  if (data?.access.canManageTasks == true) FilledButton.icon(
                    style: taskButtonStyle(), onPressed: busy ? null : () => _openForm(),
                    icon: const Icon(Icons.add, size: 18), label: const Text('Create Task'),
                  ),
                ]);
                if (constraints.maxWidth < 620) return Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [heading, const SizedBox(height: 14), actions]);
                return Row(children: [Expanded(child: heading), const SizedBox(width: 18), actions]);
              })),
              const SizedBox(height: 14),
              TaskSurface(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                LayoutBuilder(builder: (context, constraints) {
                  final search = TextField(
                    controller: _search, enabled: data != null && !busy,
                    onChanged: (value) => setState(() => _query = value.trim().toLowerCase()),
                    decoration: taskInputDecoration('Search tasks', icon: Icons.search).copyWith(
                      suffixIcon: _query.isEmpty ? null : IconButton(tooltip: 'Clear search',
                        onPressed: () { _search.clear(); setState(() => _query = ''); }, icon: const Icon(Icons.close)),
                    ),
                  );
                  final filterButton = OutlinedButton.icon(
                    onPressed: data == null || busy ? null : () => _filters(data),
                    icon: const Icon(Icons.filter_alt_outlined, size: 18), label: const Text('Filters'),
                  );
                  if (constraints.maxWidth < 420) return Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [search, const SizedBox(height: 10), filterButton]);
                  return Row(children: [Expanded(child: search), const SizedBox(width: 12), filterButton]);
                }),
                if (data != null) ...[
                  const SizedBox(height: 14),
                  Wrap(spacing: 10, runSpacing: 8, children: [
                    Text(data.access.isManager ? 'All Tasks (${tasks.length})' : 'Assigned Tasks (${tasks.length})',
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                    if (data.filter.categoryId != null) Text('Category: ${_categoryName(data, data.filter.categoryId!)}'),
                    if (data.access.isManager && data.filter.memberId != null) Text('Member: ${_memberName(data, data.filter.memberId!)}'),
                    if (data.filter.fromDate != null) Text('From: ${projectDateShort(data.filter.fromDate!)}'),
                    if (data.filter.toDate != null) Text('To: ${projectDateShort(data.filter.toDate!)}'),
                  ]),
                ],
              ])),
              const SizedBox(height: 14),
              if (state is TaskInitial || state is TaskLoading)
                const Padding(padding: EdgeInsets.all(36), child: Center(child: CircularProgressIndicator()))
              else if (state is TaskUnavailable)
                TaskNotice(icon: Icons.link_off_outlined, title: 'Tasks unavailable', message: state.message)
              else if (state is TaskFailure && data == null)
                TaskNotice(icon: Icons.error_outline, title: 'Unable to load tasks', message: state.message,
                  onRetry: () => context.read<TaskBloc>().add(const LoadTasks()))
              else if (data != null) ...[
                if (state is TaskWorking) const LinearProgressIndicator(minHeight: 2),
                if (tasks.isEmpty)
                  const TaskNotice(icon: Icons.task_alt, title: 'No matching tasks', message: 'Try changing your search or filters.')
                else LayoutBuilder(builder: (context, constraints) {
                  if (constraints.maxWidth >= 900) return TaskSurface(
                    padding: const EdgeInsets.all(8),
                    child: SingleChildScrollView(scrollDirection: Axis.horizontal,
                      child: DataTable(columns: const [
                        DataColumn(label: Text('Task')), DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Priority')), DataColumn(label: Text('Category')),
                        DataColumn(label: Text('Member')), DataColumn(label: Text('Due date')),
                        DataColumn(label: Text('Actions')),
                      ], rows: tasks.map((task) => DataRow(cells: [
                        DataCell(SizedBox(width: 210, child: Text(task.title, maxLines: 2, overflow: TextOverflow.ellipsis)), onTap: () => _details(task)),
                        DataCell(TaskStatusBadge(status: task.status)),
                        DataCell(Text(task.priority.isEmpty ? '—' : task.priority)),
                        DataCell(SizedBox(width: 130, child: Text(_taskCategory(data, task), overflow: TextOverflow.ellipsis))),
                        DataCell(SizedBox(width: 150, child: Text(_taskMember(data, task), overflow: TextOverflow.ellipsis))),
                        DataCell(Text(task.dueDate == null ? '—' : projectDateShort(task.dueDate!))),
                        DataCell(_actions(data, task, busy)),
                      ])).toList()),
                    ),
                  );
                  return Column(children: tasks.map((task) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TaskSurface(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const ProjectIconTile(icon: Icons.task_alt, color: AppPallete.salesPrimary, background: AppPallete.salesPrimarySoft, size: 40, radius: 12),
                        const SizedBox(width: 12),
                        Expanded(child: InkWell(onTap: () => _details(task), child: Text(task.title,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)))),
                        _actions(data, task, busy),
                      ]),
                      const SizedBox(height: 10),
                      if (task.description.isNotEmpty) ...[
                        Text(task.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppPallete.textSecondary)),
                        const SizedBox(height: 12),
                      ],
                      Wrap(spacing: 10, runSpacing: 8, children: [
                        TaskStatusBadge(status: task.status),
                        if (task.priority.isNotEmpty) SizedBox(width: 160,
                          child: Text('Priority: ${task.priority}', maxLines: 2, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: AppPallete.textSecondary))),
                      ]),
                      const Divider(height: 26),
                      Wrap(spacing: 14, runSpacing: 12, children: [
                        TaskInfo(label: 'Category', value: _taskCategory(data, task)),
                        TaskInfo(label: 'Assigned member', value: _taskMember(data, task)),
                        TaskInfo(label: 'Due date', value: task.dueDate == null ? '—' : projectDateShort(task.dueDate!)),
                        TaskInfo(label: 'Assigned by', value: task.assignedBy),
                      ]),
                    ])),
                  )).toList());
                }),
              ],
            ],
          ),
        );
      },
    ),
  );

  Widget _actions(TaskManagerData data, TaskEntity task, bool busy) => Row(mainAxisSize: MainAxisSize.min, children: [
    IconButton(tooltip: 'Task details', onPressed: busy ? null : () => _details(task), icon: const Icon(Icons.visibility_outlined, size: 20)),
    if (data.access.canManageTasks) PopupMenuButton<String>(
      enabled: !busy,
      onSelected: (action) { if (action == 'edit') { _openForm(task); } else { _delete(task); } },
      itemBuilder: (_) => const [
        PopupMenuItem(value: 'edit', child: Text('Edit')),
        PopupMenuItem(value: 'delete', child: Text('Delete')),
      ],
    ),
  ]);

  String _categoryName(TaskManagerData data, String id) => data.categories
      .where((category) => category.id == id).map((category) => category.name).firstOrNull ?? id;
  String _memberName(TaskManagerData data, String id) => data.members
      .where((member) => member.id == id).map((member) => member.displayName).firstOrNull ?? id;
  String _taskCategory(TaskManagerData data, TaskEntity task) =>
      task.categoryId == null ? (task.categoryName ?? '—')
          : data.categories.where((category) => category.id == task.categoryId)
              .map((category) => category.name).firstOrNull ?? task.categoryName ?? '—';
  String _taskMember(TaskManagerData data, TaskEntity task) => task.memberId == null
      ? 'Unassigned' : data.members.where((member) => member.id == task.memberId)
          .map((member) => member.displayName).firstOrNull ?? task.memberName ?? 'Member #${task.memberId}';
}
