import 'package:flutter/material.dart';
import 'package:optima_sync_v2/core/widgets/app_mobile_widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/task_entity.dart';
import 'package:optima_sync_v2/app/presentation/project/widgets/project_widgets.dart';
import 'package:optima_sync_v2/app/presentation/task/bloc/task_bloc.dart';
import 'package:optima_sync_v2/app/presentation/task/bloc/task_event.dart';
import 'package:optima_sync_v2/app/presentation/task/bloc/task_state.dart';
import 'package:optima_sync_v2/app/presentation/task/widgets/task_widgets.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';

class TaskFormDialog extends StatefulWidget {
  final TaskEntity? task;
  const TaskFormDialog({super.key, this.task});
  @override
  State<TaskFormDialog> createState() => _TaskFormDialogState();
}

class _TaskFormDialogState extends State<TaskFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _description;
  late final TextEditingController _priority;
  String? _categoryId;
  String? _memberId;
  DateTime? _dueDate;
  late String _status;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _title = TextEditingController(text: task?.title ?? '');
    _description = TextEditingController(text: task?.description ?? '');
    _priority = TextEditingController(text: task?.priority ?? '');
    _categoryId = task?.categoryId;
    _memberId = task?.memberId;
    _dueDate = task?.dueDate;
    final allowed = context.read<TaskBloc>().state.data?.access.allowedStatuses
        .where(kTaskStatuses.contains).toList() ?? <String>[];
    _status = task?.status ?? (allowed.isEmpty ? 'Pending' : allowed.first);
  }

  @override
  void dispose() {
    _title.dispose(); _description.dispose(); _priority.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = _dueDate ?? now;
    final date = await showDatePicker(
      context: context, initialDate: initial,
      firstDate: DateTime(initial.year < 2000 ? initial.year : 2000),
      lastDate: DateTime(initial.year > now.year + 30 ? initial.year + 1 : now.year + 30, 12, 31),
    );
    if (date != null && mounted) setState(() => _dueDate = date);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _submitted = true;
    final input = TaskInput(
      title: _title.text.trim(), description: _description.text.trim(),
      categoryId: _categoryId, memberId: _memberId, dueDate: _dueDate,
      status: _status, priority: _priority.text.trim(),
    );
    final bloc = context.read<TaskBloc>();
    if (widget.task == null) {
      bloc.add(CreateTaskSubmitted(input));
    } else {
      bloc.add(UpdateTaskSubmitted(widget.task!.id, input));
    }
  }

  @override
  Widget build(BuildContext context) => AppMobileDialog(
    backgroundColor: AppPallete.cardBackground,
    insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    child: BlocConsumer<TaskBloc, TaskState>(
      listener: (context, state) {
        final operation = widget.task == null ? 'createTask' : 'updateTask';
        if (_submitted && state is TaskLoaded && state.operation == operation) Navigator.pop(context);
      },
      builder: (context, state) {
        final data = state.data;
        if (data == null || !data.access.canManageTasks) {
          return const Padding(padding: EdgeInsets.all(24), child: Text('Task management is unavailable.'));
        }
        final working = state is TaskWorking;
        final categories = data.categories;
        final members = data.members;
        final allowed = data.access.allowedStatuses.where(kTaskStatuses.contains).toList();
        final statusItems = {...allowed, if (widget.task != null) widget.task!.status}.toList();
        return PopScope(
          canPop: !working,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620, maxHeight: 760),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(children: [
                      Expanded(child: Text(widget.task == null ? 'Create Task' : 'Edit Task',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800))),
                      IconButton(onPressed: working ? null : () => Navigator.pop(context), icon: const Icon(Icons.close)),
                    ]),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: _title, enabled: !working,
                      decoration: taskInputDecoration('Task title'),
                      validator: (value) => value == null || value.trim().isEmpty ? 'Enter a title' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(controller: _description, enabled: !working, minLines: 3, maxLines: 6,
                      decoration: taskInputDecoration('Description')),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: categories.any((c) => c.id == _categoryId) ? _categoryId : null,
                      isExpanded: true, decoration: taskInputDecoration('Category'),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('No category')),
                        ...categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name, overflow: TextOverflow.ellipsis))),
                      ],
                      validator: (_) => _categoryId != null && !categories.any((c) => c.id == _categoryId)
                          ? 'Choose an available category or clear it' : null,
                      onChanged: working ? null : (value) => setState(() => _categoryId = value),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: members.any((m) => m.id == _memberId) ? _memberId : null,
                      isExpanded: true, decoration: taskInputDecoration('Assigned member'),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('Unassigned')),
                        ...members.map((m) => DropdownMenuItem(value: m.id, child: Text(m.displayName, overflow: TextOverflow.ellipsis))),
                      ],
                      validator: (_) => _memberId != null && !members.any((m) => m.id == _memberId)
                          ? 'Choose an available member or clear it' : null,
                      onChanged: working ? null : (value) => setState(() => _memberId = value),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: statusItems.contains(_status) ? _status : null,
                      isExpanded: true, decoration: taskInputDecoration('Status'),
                      items: statusItems.map((status) => DropdownMenuItem(value: status, child: Text(status))).toList(),
                      onChanged: working ? null : (value) { if (value != null) setState(() => _status = value); },
                      validator: (_) => allowed.contains(_status) || _status == widget.task?.status
                          ? null : 'No permitted status is available',
                    ),
                    const SizedBox(height: 12),
                    TextFormField(controller: _priority, enabled: !working, decoration: taskInputDecoration('Priority')),
                    const SizedBox(height: 12),
                    InputDecorator(
                      decoration: taskInputDecoration('Due date', icon: Icons.calendar_today_outlined),
                      child: Row(children: [
                        Expanded(child: InkWell(onTap: working ? null : _pickDate,
                          child: Padding(padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(_dueDate == null ? 'Choose a date' : projectDateShort(_dueDate!))))),
                        if (_dueDate != null) IconButton(onPressed: working ? null : () => setState(() => _dueDate = null),
                          tooltip: 'Clear date', icon: const Icon(Icons.close, size: 18)),
                      ]),
                    ),
                    if (widget.task != null) ...[
                      const SizedBox(height: 12),
                      Text('Assigned by: ${widget.task!.assignedBy}', style: const TextStyle(color: AppPallete.textSecondary)),
                    ],
                    if (_submitted && state is TaskFailure) ...[
                      const SizedBox(height: 12),
                      Text(state.message, style: const TextStyle(color: Colors.redAccent)),
                    ],
                    const SizedBox(height: 20),
                    Row(children: [
                      Expanded(child: OutlinedButton(onPressed: working ? null : () => Navigator.pop(context), child: const Text('Cancel'))),
                      const SizedBox(width: 10),
                      Expanded(child: FilledButton(
                        style: taskButtonStyle(), onPressed: working ? null : _submit,
                        child: working ? const SizedBox(width: 18, height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : Text(widget.task == null ? 'Create Task' : 'Save Changes'),
                      )),
                    ]),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}
