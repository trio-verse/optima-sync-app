import 'package:flutter/material.dart';
import 'package:optima_sync_v2/core/widgets/app_mobile_widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/task_entity.dart';
import 'package:optima_sync_v2/app/presentation/task/bloc/task_bloc.dart';
import 'package:optima_sync_v2/app/presentation/task/bloc/task_event.dart';
import 'package:optima_sync_v2/app/presentation/task/bloc/task_state.dart';
import 'package:optima_sync_v2/app/presentation/task/widgets/task_widgets.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';

class TaskCategoriesScreen extends StatelessWidget {
  const TaskCategoriesScreen({super.key});

  void _form(BuildContext context, [TaskCategoryEntity? category]) =>
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => BlocProvider.value(
          value: context.read<TaskBloc>(),
          child: _CategoryFormDialog(category: category),
        ),
      );

  Future<void> _delete(
    BuildContext context,
    TaskCategoryEntity category,
  ) async {
    final confirmed = await confirmTaskRemoval(
      context,
      'Delete category?',
      'Delete "${category.name}"?',
    );
    if (confirmed && context.mounted)
      context.read<TaskBloc>().add(DeleteTaskCategorySubmitted(category.id));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppPallete.pageBackground,
    appBar: AppBar(
      backgroundColor: AppPallete.cardBackground,
      surfaceTintColor: AppPallete.cardBackground,
      title: const Text(
        'Task Categories',
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
    ),
    body: BlocConsumer<TaskBloc, TaskState>(
      listener: (context, state) {
        if (ModalRoute.of(context)?.isCurrent != true) return;
        final message = state is TaskLoaded
            ? state.message
            : state is TaskFailure
            ? state.message
            : null;
        if (message != null)
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
      },
      builder: (context, state) {
        final data = state.data;
        if (data == null)
          return const Padding(
            padding: EdgeInsets.all(16),
            child: TaskNotice(
              icon: Icons.category_outlined,
              title: 'Categories unavailable',
              message: 'Return to Task Manager to reload your tasks.',
            ),
          );
        final working = state is TaskWorking;
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
          children: [
            TaskSurface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Organize your tasks by category.',
                    style: TextStyle(color: AppPallete.textSecondary),
                  ),
                  if (data.access.canManageCategories) ...[
                    const SizedBox(height: 14),
                    FilledButton.icon(
                      style: taskButtonStyle(),
                      onPressed: working ? null : () => _form(context),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Create Category'),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 14),
            if (working) const LinearProgressIndicator(minHeight: 2),
            if (data.categories.isEmpty)
              const TaskNotice(
                icon: Icons.category_outlined,
                title: 'No categories yet',
                message: 'Task categories will appear here.',
              )
            else
              ...data.categories.map(
                (category) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TaskSurface(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.category_outlined,
                          color: AppPallete.salesPrimary,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            category.name,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        if (data.access.canManageCategories)
                          PopupMenuButton<String>(
                            enabled: !working,
                            onSelected: (value) {
                              if (value == 'edit') {
                                _form(context, category);
                              } else {
                                _delete(context, category);
                              }
                            },
                            itemBuilder: (_) => const [
                              PopupMenuItem(value: 'edit', child: Text('Edit')),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    ),
  );
}

class _CategoryFormDialog extends StatefulWidget {
  final TaskCategoryEntity? category;
  const _CategoryFormDialog({this.category});
  @override
  State<_CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<_CategoryFormDialog> {
  final _key = GlobalKey<FormState>();
  late final TextEditingController _name;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.category?.name ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_key.currentState!.validate()) return;
    _submitted = true;
    final bloc = context.read<TaskBloc>();
    if (widget.category == null) {
      bloc.add(CreateTaskCategorySubmitted(_name.text.trim()));
    } else {
      bloc.add(
        UpdateTaskCategorySubmitted(widget.category!.id, _name.text.trim()),
      );
    }
  }

  @override
  Widget build(BuildContext context) => AppMobileDialog(
    backgroundColor: AppPallete.cardBackground,
    insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    child: BlocConsumer<TaskBloc, TaskState>(
      listener: (context, state) {
        final operation = widget.category == null
            ? 'createCategory'
            : 'updateCategory';
        if (_submitted && state is TaskLoaded && state.operation == operation)
          Navigator.pop(context);
      },
      builder: (context, state) {
        final working = state is TaskWorking;
        final allowed = state.data?.access.canManageCategories == true;
        return PopScope(
          canPop: !working,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _key,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.category == null
                          ? 'Create Category'
                          : 'Edit Category',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: _name,
                      enabled: !working && allowed,
                      decoration: taskInputDecoration('Category name'),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Enter a category name'
                          : null,
                    ),
                    if (_submitted && state is TaskFailure) ...[
                      const SizedBox(height: 12),
                      Text(
                        state.message,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: working
                                ? null
                                : () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton(
                            style: taskButtonStyle(),
                            onPressed: working || !allowed ? null : _submit,
                            child: working
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Save'),
                          ),
                        ),
                      ],
                    ),
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
