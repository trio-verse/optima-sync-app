import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/member_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/task_entity.dart';
import 'package:optima_sync_v2/app/domain/usecases/member_usecases.dart';
import 'package:optima_sync_v2/app/domain/usecases/task_usecases.dart';
import 'package:optima_sync_v2/core/errors/failures/failures.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskUsecases usecases;
  final MemberUsecases memberUsecases;
  bool _busy = false;

  TaskBloc({required this.usecases, required this.memberUsecases})
    : super(TaskInitial()) {
    on<LoadTasks>(_load);
    on<CreateTaskSubmitted>(_create);
    on<UpdateTaskSubmitted>(_update);
    on<DeleteTaskSubmitted>(_delete);
    on<ChangeTaskStatusSubmitted>(_changeStatus);
    on<CreateTaskCategorySubmitted>(_createCategory);
    on<UpdateTaskCategorySubmitted>(_updateCategory);
    on<DeleteTaskCategorySubmitted>(_deleteCategory);
  }

  String _message(WhateverFailure failure) => failure.when(
    serverError: () => 'The task request failed. Please try again.',
    whatoffline: () => 'No internet connection.',
    database: () => 'Unable to update the local data.',
  );

  Future<void> _load(LoadTasks event, Emitter<TaskState> emit) async {
    if (_busy) return;
    if (!usecases.isConfigured) {
      emit(TaskUnavailable(usecases.unavailableMessage));
      return;
    }
    final filter = event.filter ?? state.data?.filter ?? const TaskFilter();
    if (!filter.isValid) {
      emit(
        TaskFailure(
          'From date must be before or equal to To date.',
          data: state.data,
        ),
      );
      return;
    }

    _busy = true;
    emit(TaskLoading());
    try {
      final accessResult = await usecases.getAccess();
      final access = accessResult.fold<TaskManagerAccess?>((failure) {
        emit(TaskFailure(_message(failure)));
        return null;
      }, (access) => access);
      if (access == null) return;
      if (!access.canViewTasks) {
        emit(
          const TaskUnavailable(
            'Task access could not be verified for your account.',
          ),
        );
        return;
      }

      final scopedFilter = filter.forAccess(access);
      final taskResult = await usecases.getTasks(scopedFilter);
      final tasks = taskResult.fold<List<TaskEntity>?>((failure) {
        emit(TaskFailure(_message(failure)));
        return null;
      }, (tasks) => tasks.where(access.canViewTask).toList());
      if (tasks == null) return;
      final categoryResult = await usecases.getCategories();
      final categories = categoryResult.fold<List<TaskCategoryEntity>?>((
        failure,
      ) {
        emit(TaskFailure(_message(failure)));
        return null;
      }, (categories) => categories);
      if (categories == null) return;

      List<MemberEntity> members = const [];
      if (access.isManager) {
        final memberResult = await memberUsecases.getMembers();
        final loadedMembers = memberResult.fold<List<MemberEntity>?>((failure) {
          emit(TaskFailure(_message(failure)));
          return null;
        }, (members) => members);
        if (loadedMembers == null) return;
        members = loadedMembers;
      }
      emit(
        TaskLoaded(
          TaskManagerData(
            access: access,
            tasks: tasks,
            categories: categories,
            members: members,
            filter: scopedFilter,
          ),
        ),
      );
    } finally {
      _busy = false;
    }
  }

  TaskManagerData? _authorize(
    Emitter<TaskState> emit,
    bool Function(TaskManagerData) allowed,
  ) {
    if (_busy) return null;
    final data = state.data;
    if (data == null || !allowed(data)) {
      emit(
        TaskFailure(
          'This action is not permitted for your account.',
          data: data,
        ),
      );
      return null;
    }
    return data;
  }

  bool _hasTask(TaskManagerData data, String id) =>
      data.tasks.any((task) => task.id == id && data.access.canViewTask(task));

  bool _validInput(
    TaskInput input,
    TaskManagerData data,
    Emitter<TaskState> emit, {
    TaskEntity? existing,
  }) {
    if (input.title.trim().isEmpty || !kTaskStatuses.contains(input.status)) {
      emit(TaskFailure('Enter a task title and a valid status.', data: data));
      return false;
    }
    if (input.status != existing?.status &&
        !data.access.allowedStatuses.contains(input.status)) {
      emit(
        TaskFailure(
          'This task status is not permitted for your account.',
          data: data,
        ),
      );
      return false;
    }
    if (input.memberId != null &&
        !data.members.any((member) => member.id == input.memberId)) {
      emit(TaskFailure('Select an available member.', data: data));
      return false;
    }
    if (input.categoryId != null &&
        !data.categories.any((category) => category.id == input.categoryId)) {
      emit(TaskFailure('Select an available category.', data: data));
      return false;
    }
    return true;
  }

  Future<void> _work<T>({
    required TaskManagerData data,
    required Emitter<TaskState> emit,
    required String operation,
    required String message,
    required Future<Either<WhateverFailure, T>> Function() request,
    required TaskManagerData Function(T result) update,
  }) async {
    _busy = true;
    emit(TaskWorking(data, operation));
    try {
      final result = await request();
      result.fold(
        (failure) => emit(TaskFailure(_message(failure), data: data)),
        (value) => emit(
          TaskLoaded(update(value), message: message, operation: operation),
        ),
      );
    } finally {
      _busy = false;
    }
  }

  TaskManagerData _replaceTask(TaskManagerData data, TaskEntity task) =>
      data.copyWith(
        tasks: data.tasks
            .map((item) => item.id == task.id ? task : item)
            .toList(),
      );

  Future<void> _create(
    CreateTaskSubmitted event,
    Emitter<TaskState> emit,
  ) async {
    final data = _authorize(emit, (data) => data.access.canManageTasks);
    if (data == null || !_validInput(event.input, data, emit)) return;
    await _work<TaskEntity>(
      data: data,
      emit: emit,
      operation: 'createTask',
      message: 'Task created successfully.',
      request: () => usecases.createTask(event.input),
      update: (task) => data.copyWith(tasks: [task, ...data.tasks]),
    );
  }

  Future<void> _update(
    UpdateTaskSubmitted event,
    Emitter<TaskState> emit,
  ) async {
    final data = _authorize(
      emit,
      (data) => data.access.canManageTasks && _hasTask(data, event.taskId),
    );
    if (data == null ||
        !_validInput(
          event.input,
          data,
          emit,
          existing: data.tasks.firstWhere((task) => task.id == event.taskId),
        ))
      return;
    await _work<TaskEntity>(
      data: data,
      emit: emit,
      operation: 'updateTask',
      message: 'Task updated successfully.',
      request: () => usecases.updateTask(event.taskId, event.input),
      update: (task) => _replaceTask(data, task),
    );
  }

  Future<void> _delete(
    DeleteTaskSubmitted event,
    Emitter<TaskState> emit,
  ) async {
    final data = _authorize(
      emit,
      (data) => data.access.canManageTasks && _hasTask(data, event.taskId),
    );
    if (data == null) return;
    await _work<void>(
      data: data,
      emit: emit,
      operation: 'deleteTask',
      message: 'Task deleted successfully.',
      request: () => usecases.deleteTask(event.taskId),
      update: (_) => data.copyWith(
        tasks: data.tasks.where((task) => task.id != event.taskId).toList(),
      ),
    );
  }

  Future<void> _changeStatus(
    ChangeTaskStatusSubmitted event,
    Emitter<TaskState> emit,
  ) async {
    final data = _authorize(
      emit,
      (data) => data.tasks.any(
        (task) =>
            task.id == event.taskId &&
            data.access.canChangeStatus(task) &&
            data.access.allowedStatuses.contains(event.status) &&
            kTaskStatuses.contains(event.status),
      ),
    );
    if (data == null) return;
    await _work<TaskEntity>(
      data: data,
      emit: emit,
      operation: 'changeStatus',
      message: 'Task status updated successfully.',
      request: () => usecases.changeTaskStatus(event.taskId, event.status),
      update: (task) => _replaceTask(data, task),
    );
  }

  Future<void> _createCategory(
    CreateTaskCategorySubmitted event,
    Emitter<TaskState> emit,
  ) async {
    final data = _authorize(emit, (data) => data.access.canManageCategories);
    if (data == null) return;
    if (event.name.trim().isEmpty) {
      emit(TaskFailure('Enter a category name.', data: data));
      return;
    }
    await _work<TaskCategoryEntity>(
      data: data,
      emit: emit,
      operation: 'createCategory',
      message: 'Category created successfully.',
      request: () => usecases.createCategory(event.name.trim()),
      update: (category) =>
          data.copyWith(categories: [...data.categories, category]),
    );
  }

  Future<void> _updateCategory(
    UpdateTaskCategorySubmitted event,
    Emitter<TaskState> emit,
  ) async {
    final data = _authorize(
      emit,
      (data) =>
          data.access.canManageCategories &&
          data.categories.any((category) => category.id == event.categoryId),
    );
    if (data == null) return;
    if (event.name.trim().isEmpty) {
      emit(TaskFailure('Enter a category name.', data: data));
      return;
    }
    await _work<TaskCategoryEntity>(
      data: data,
      emit: emit,
      operation: 'updateCategory',
      message: 'Category updated successfully.',
      request: () =>
          usecases.updateCategory(event.categoryId, event.name.trim()),
      update: (category) => data.copyWith(
        categories: data.categories
            .map((item) => item.id == category.id ? category : item)
            .toList(),
      ),
    );
  }

  Future<void> _deleteCategory(
    DeleteTaskCategorySubmitted event,
    Emitter<TaskState> emit,
  ) async {
    final data = _authorize(
      emit,
      (data) =>
          data.access.canManageCategories &&
          data.categories.any((category) => category.id == event.categoryId),
    );
    if (data == null) return;
    await _work<void>(
      data: data,
      emit: emit,
      operation: 'deleteCategory',
      message: 'Category deleted successfully.',
      request: () => usecases.deleteCategory(event.categoryId),
      update: (_) {
        final filter = data.filter;
        return data.copyWith(
          categories: data.categories
              .where((category) => category.id != event.categoryId)
              .toList(),
          filter: TaskFilter(
            memberId: filter.memberId,
            categoryId: filter.categoryId == event.categoryId
                ? null
                : filter.categoryId,
            fromDate: filter.fromDate,
            toDate: filter.toDate,
          ),
        );
      },
    );
  }
}
