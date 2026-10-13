import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/task_entity.dart';
import 'package:optima_sync_v2/app/presentation/project/widgets/project_widgets.dart';
import 'package:optima_sync_v2/app/presentation/task/bloc/task_bloc.dart';
import 'package:optima_sync_v2/app/presentation/task/bloc/task_event.dart';
import 'package:optima_sync_v2/app/presentation/task/bloc/task_state.dart';
import 'package:optima_sync_v2/app/presentation/task/pages/task_form_dialog.dart';
import 'package:optima_sync_v2/app/presentation/task/widgets/task_widgets.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';

class TaskDetailsScreen extends StatelessWidget {
  final String taskId;
  const TaskDetailsScreen({super.key, required this.taskId});

  Future<void> _status(
    BuildContext context,
    TaskEntity task,
    TaskManagerAccess access,
  ) async {
    final statuses = access.allowedStatuses
        .where(kTaskStatuses.contains)
        .toSet()
        .toList();
    final status = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Change Status'),
        children: statuses
            .map(
              (status) => SimpleDialogOption(
                onPressed: () => Navigator.pop(context, status),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(status),
                ),
              ),
            )
            .toList(),
      ),
    );
    if (status != null && status != task.status && context.mounted) {
      context.read<TaskBloc>().add(ChangeTaskStatusSubmitted(task.id, status));
    }
  }

  Future<void> _delete(BuildContext context, TaskEntity task) async {
    final confirmed = await confirmTaskRemoval(
      context,
      'Delete task?',
      'Delete "${task.title}"?',
    );
    if (confirmed && context.mounted)
      context.read<TaskBloc>().add(DeleteTaskSubmitted(task.id));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppPallete.pageBackground,
    appBar: AppBar(
      backgroundColor: AppPallete.cardBackground,
      surfaceTintColor: AppPallete.cardBackground,
      title: const Text(
        'Task Details',
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
    ),
    body: BlocConsumer<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state is TaskLoaded &&
            state.operation == 'deleteTask' &&
            !state.data.tasks.any((task) => task.id == taskId)) {
          Navigator.pop(context);
        } else if (state is TaskLoaded &&
            state.message != null &&
            ModalRoute.of(context)?.isCurrent == true) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message!)));
        }
      },
      builder: (context, state) {
        final data = state.data;
        final task = data == null
            ? null
            : data.tasks
                  .where(
                    (task) =>
                        task.id == taskId && data.access.canViewTask(task),
                  )
                  .firstOrNull;
        if (task == null || data == null)
          return const Padding(
            padding: EdgeInsets.all(16),
            child: TaskNotice(
              icon: Icons.task_outlined,
              title: 'Task unavailable',
              message: 'Return to Task Manager to reload your tasks.',
            ),
          );
        final working = state is TaskWorking;
        final category = data.categories
            .where((category) => category.id == task.categoryId)
            .firstOrNull;
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
          children: [
            if (working) const LinearProgressIndicator(minHeight: 2),
            TaskSurface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppPallete.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TaskStatusBadge(status: task.status),
                  const SizedBox(height: 20),
                  const Text(
                    'Description',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    task.description.isEmpty ? '—' : task.description,
                    style: const TextStyle(
                      color: AppPallete.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const Divider(height: 32),
                  Wrap(
                    spacing: 18,
                    runSpacing: 18,
                    children: [
                      TaskInfo(
                        label: 'Category',
                        value: category?.name ?? task.categoryName ?? '—',
                      ),
                      TaskInfo(
                        label: 'Assigned member',
                        value:
                            task.memberName ??
                            (task.memberId == null
                                ? 'Unassigned'
                                : 'Member #${task.memberId}'),
                      ),
                      TaskInfo(
                        label: 'Due date',
                        value: task.dueDate == null
                            ? '—'
                            : projectDateShort(task.dueDate!),
                      ),
                      TaskInfo(label: 'Priority', value: task.priority),
                      TaskInfo(label: 'Assigned by', value: task.assignedBy),
                    ],
                  ),
                  if (data.access.canManageTasks ||
                      data.access.canChangeStatus(task)) ...[
                    const Divider(height: 32),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        if (data.access.canChangeStatus(task))
                          FilledButton.icon(
                            style: taskButtonStyle(),
                            onPressed: working
                                ? null
                                : () => _status(context, task, data.access),
                            icon: const Icon(Icons.sync, size: 18),
                            label: const Text('Change Status'),
                          ),
                        if (data.access.canManageTasks) ...[
                          OutlinedButton.icon(
                            onPressed: working
                                ? null
                                : () => showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (_) => BlocProvider.value(
                                      value: context.read<TaskBloc>(),
                                      child: TaskFormDialog(task: task),
                                    ),
                                  ),
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            label: const Text('Edit Task'),
                          ),
                          OutlinedButton.icon(
                            onPressed: working
                                ? null
                                : () => _delete(context, task),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.redAccent,
                            ),
                            icon: const Icon(Icons.delete_outline, size: 18),
                            label: const Text('Delete'),
                          ),
                        ],
                      ],
                    ),
                  ],
                  if (state is TaskFailure) ...[
                    const SizedBox(height: 14),
                    Text(
                      state.message,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    ),
  );
}
