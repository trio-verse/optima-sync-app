import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:optima_sync_v2/app/data/repoImp/task_repo_impl.dart';
import 'package:optima_sync_v2/app/data/sources/local_data/org_local_data_source.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/task_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/member_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/task_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/member/member_repo.dart';
import 'package:optima_sync_v2/app/domain/usecases/member_usecases.dart';
import 'package:optima_sync_v2/app/domain/usecases/task_usecases.dart';
import 'package:optima_sync_v2/app/presentation/task/bloc/task_bloc.dart';
import 'package:optima_sync_v2/app/presentation/task/bloc/task_event.dart';
import 'package:optima_sync_v2/app/presentation/task/bloc/task_state.dart';
import 'package:optima_sync_v2/app/presentation/task/screen/task_manager_screen.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';
import 'package:optima_sync_v2/core/network/http_client_helper.dart';

const _employee = TaskManagerAccess(role: 'employee', memberId: 'member-1');
const _input = TaskInput(
  title: 'Updated title',
  description: '',
  status: 'Pending',
  priority: '',
);

TaskEntity _task(
  String id,
  String memberId, {
  DateTime? dueDate,
  String status = 'Pending',
}) => TaskEntity(
  id: id,
  title: id,
  description: '',
  memberId: memberId,
  dueDate: dueDate,
  status: status,
  priority: '',
  assignedBy: 'Test manager',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('Organization admin/member roles do not grant task-manager access', () {
    for (final role in ['admin', 'member', 'unknown']) {
      final access = TaskManagerAccess(
        role: role,
        memberId: 'member-1',
        mayManageTasks: true,
        mayManageCategories: true,
      );
      expect(access.canViewTasks, false);
      expect(access.canManageTasks, false);
      expect(access.canManageCategories, false);
    }
    expect(const TaskManagerAccess(role: 'employee').canViewTasks, false);
  });

  test(
    'Employee status permission is explicit and restricted to their own task',
    () {
      final own = _task('own', 'member-1');
      final other = _task('other', 'member-2');
      expect(_employee.canChangeStatus(own), false);
      const access = TaskManagerAccess(
        role: 'employee',
        memberId: 'member-1',
        mayManageTasks: true,
        mayManageCategories: true,
        mayChangeOwnStatus: true,
        allowedStatuses: ['In Progress'],
      );
      expect(access.canManageTasks, false);
      expect(access.canManageCategories, false);
      expect(access.canChangeStatus(own), true);
      expect(access.canChangeStatus(other), false);
    },
  );

  test(
    'Due-date filters include both boundary days and reject undated tasks',
    () {
      final filter = TaskFilter(
        fromDate: DateTime(2026, 10, 5),
        toDate: DateTime(2026, 10, 6),
      );
      expect(
        filter.matches(
          _task('first', 'member-1', dueDate: DateTime(2026, 10, 5, 0)),
        ),
        true,
      );
      expect(
        filter.matches(
          _task('last', 'member-1', dueDate: DateTime(2026, 10, 6, 23, 59)),
        ),
        true,
      );
      expect(
        filter.matches(
          _task('later', 'member-1', dueDate: DateTime(2026, 10, 7)),
        ),
        false,
      );
      expect(filter.matches(_task('undated', 'member-1')), false);
      expect(
        TaskFilter(
          fromDate: DateTime(2026, 10, 6),
          toDate: DateTime(2026, 10, 5),
        ).isValid,
        false,
      );
    },
  );

  test('Missing API configuration does not read tasks or members', () async {
    final (bloc, source, members) = await _fixture(
      _employee,
      configured: false,
    );
    final done = bloc.stream.firstWhere((state) => state is TaskUnavailable);
    bloc.add(const LoadTasks());
    await done;
    expect(source.filters, isEmpty);
    expect(members.readCount, 0);
  });

  test(
    'Employee filter is scoped to their membership and discards other tasks',
    () async {
      final (bloc, source, members) = await _fixture(_employee);
      final done = bloc.stream.firstWhere((state) => state is TaskLoaded);
      bloc.add(const LoadTasks(filter: TaskFilter(memberId: 'member-2')));
      final loaded = await done as TaskLoaded;
      expect(source.filters.single.memberId, 'member-1');
      expect(loaded.data.tasks.map((task) => task.id), ['own']);
      expect(loaded.data.visibleTasks.map((task) => task.id), ['own']);
      expect(members.readCount, 0);
    },
  );

  final forbidden = <String, TaskEvent>{
    'create task': const CreateTaskSubmitted(_input),
    'edit task': const UpdateTaskSubmitted('own', _input),
    'delete task': const DeleteTaskSubmitted('own'),
    'change status': const ChangeTaskStatusSubmitted('own', 'Completed'),
    'create category': const CreateTaskCategorySubmitted('Category'),
    'edit category': const UpdateTaskCategorySubmitted(
      'category-1',
      'Category',
    ),
    'delete category': const DeleteTaskCategorySubmitted('category-1'),
  };
  for (final entry in forbidden.entries) {
    test('Employee cannot ${entry.key} without permission', () async {
      final (bloc, source, _) = await _fixture(_employee);
      await _load(bloc);
      final done = bloc.stream.firstWhere((state) => state is TaskFailure);
      bloc.add(entry.value);
      final failure = await done as TaskFailure;
      expect(failure.message, contains('not permitted'));
      expect(source.writeCount, 0);
      expect(failure.data!.tasks.single.id, 'own');
    });
  }

  test(
    'Permitted own-task status update displays the returned server status',
    () async {
      const access = TaskManagerAccess(
        role: 'employee',
        memberId: 'member-1',
        mayChangeOwnStatus: true,
        allowedStatuses: ['In Progress'],
      );
      final (bloc, source, _) = await _fixture(access);
      await _load(bloc);
      final done = bloc.stream.firstWhere(
        (state) => state is TaskLoaded && state.operation == 'changeStatus',
      );
      bloc.add(const ChangeTaskStatusSubmitted('own', 'In Progress'));
      final loaded = await done as TaskLoaded;
      expect(source.writeCount, 1);
      expect(loaded.data.tasks.single.status, 'In Progress');
    },
  );

  test(
    'Failed status update retains the original task and emits no success',
    () async {
      const access = TaskManagerAccess(
        role: 'employee',
        memberId: 'member-1',
        mayChangeOwnStatus: true,
        allowedStatuses: ['In Progress'],
      );
      final (bloc, source, _) = await _fixture(access);
      source.failStatus = true;
      await _load(bloc);
      final done = bloc.stream.firstWhere((state) => state is TaskFailure);
      bloc.add(const ChangeTaskStatusSubmitted('own', 'In Progress'));
      final failure = await done as TaskFailure;
      expect(failure.data!.tasks.single.status, 'Pending');
    },
  );

  test(
    'Verified manager can manage tasks and categories using server results',
    () async {
      const access = TaskManagerAccess(
        role: 'manager',
        mayManageTasks: true,
        mayManageCategories: true,
        allowedStatuses: kTaskStatuses,
      );
      final (bloc, source, members) = await _fixture(access);
      await _load(bloc);
      expect(members.readCount, 1);
      final created = await _success(
        bloc,
        const CreateTaskSubmitted(_input),
        'createTask',
      );
      expect(created.data.tasks.first.id, 'created-task');
      expect(
        created.data.tasks.first.assignedBy,
        'Server authenticated manager',
      );
      final updated = await _success(
        bloc,
        const UpdateTaskSubmitted(
          'created-task',
          TaskInput(
            title: 'Edited',
            description: '',
            status: 'Completed',
            priority: '',
          ),
        ),
        'updateTask',
      );
      expect(updated.data.tasks.first.title, 'Edited');
      expect(updated.data.tasks.first.status, 'Completed');
      final deleted = await _success(
        bloc,
        const DeleteTaskSubmitted('created-task'),
        'deleteTask',
      );
      expect(
        deleted.data.tasks.any((task) => task.id == 'created-task'),
        false,
      );
      await _success(
        bloc,
        const CreateTaskCategorySubmitted('New category'),
        'createCategory',
      );
      final categoryUpdated = await _success(
        bloc,
        const UpdateTaskCategorySubmitted('new-category', 'Renamed category'),
        'updateCategory',
      );
      expect(categoryUpdated.data.categories.last.name, 'Renamed category');
      final categoryDeleted = await _success(
        bloc,
        const DeleteTaskCategorySubmitted('new-category'),
        'deleteCategory',
      );
      expect(
        categoryDeleted.data.categories.any(
          (category) => category.id == 'new-category',
        ),
        false,
      );
      expect(source.writeCount, 6);
    },
  );

  testWidgets(
    'Unavailable screen and independent drawer items fit a narrow screen',
    (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final (bloc, _, _) = await _fixture(_employee, configured: false);
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: bloc,
            child: const TaskManagerScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Tasks unavailable'), findsOneWidget);
      expect(find.text('Create Task'), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();
      final dashboard = tester.getTopLeft(find.text('Dashboard')).dy;
      final projects = tester.getTopLeft(find.text('Projects')).dy;
      final tasks = tester
          .getTopLeft(
            find.descendant(
              of: find.byType(Drawer),
              matching: find.text('Task Manager'),
            ),
          )
          .dy;
      final hr = tester.getTopLeft(find.text('HR')).dy;
      expect(dashboard, lessThan(projects));
      expect(projects, lessThan(tasks));
      expect(tasks, lessThan(hr));
      expect(tester.takeException(), isNull);
    },
  );
}

Future<TaskLoaded> _success(
  TaskBloc bloc,
  TaskEvent event,
  String operation,
) async {
  final done = bloc.stream.firstWhere(
    (state) => state is TaskLoaded && state.operation == operation,
  );
  bloc.add(event);
  return await done as TaskLoaded;
}

Future<void> _load(TaskBloc bloc) async {
  final done = bloc.stream.firstWhere((state) => state is TaskLoaded);
  bloc.add(const LoadTasks());
  await done;
}

Future<(TaskBloc, _FixtureTaskSource, _FixtureMemberRepo)> _fixture(
  TaskManagerAccess access, {
  bool configured = true,
}) async {
  SharedPreferences.setMockInitialValues({});
  final storage = await SharedPreferences.getInstance();
  final client = http.Client();
  addTearDown(client.close);
  final source = _FixtureTaskSource(
    client: HttpClientHelper(storage: storage, client: client),
    orgLocalDataSource: OrgLocalDataSource(storage: storage),
    access: access,
    configured: configured,
  );
  final members = _FixtureMemberRepo();
  final bloc = TaskBloc(
    usecases: TaskUsecases(repo: TaskRepositoryImpl(remoteDataSource: source)),
    memberUsecases: MemberUsecases(repo: members),
  );
  addTearDown(bloc.close);
  return (bloc, source, members);
}

// Test-only fixtures never participate in production dependency registration.
class _FixtureTaskSource extends TaskRemoteDataSource {
  final TaskManagerAccess access;
  final bool configured;
  final filters = <TaskFilter>[];
  int writeCount = 0;
  bool failStatus = false;
  _FixtureTaskSource({
    required super.client,
    required super.orgLocalDataSource,
    required this.access,
    required this.configured,
  });
  @override
  bool get isConfigured => configured;
  @override
  Future<TaskManagerAccess> getAccess() async => access;
  @override
  Future<List<TaskEntity>> getTasks(TaskFilter filter) async {
    filters.add(filter);
    return [_task('own', 'member-1'), _task('other', 'member-2')];
  }

  @override
  Future<List<TaskCategoryEntity>> getCategories() async => [
    const TaskCategoryEntity(id: 'category-1', name: 'Test category'),
  ];
  @override
  Future<TaskEntity> createTask(TaskInput input) async {
    writeCount++;
    return _fromInput('created-task', input);
  }

  @override
  Future<TaskEntity> updateTask(String id, TaskInput input) async {
    writeCount++;
    return _fromInput(id, input);
  }

  @override
  Future<void> deleteTask(String id) async {
    writeCount++;
  }

  @override
  Future<TaskEntity> changeTaskStatus(String id, String status) async {
    writeCount++;
    if (failStatus) throw StateError('Server failure');
    return _task(id, 'member-1', status: status);
  }

  @override
  Future<TaskCategoryEntity> createCategory(String name) async {
    writeCount++;
    return TaskCategoryEntity(id: 'new-category', name: name);
  }

  @override
  Future<TaskCategoryEntity> updateCategory(String id, String name) async {
    writeCount++;
    return TaskCategoryEntity(id: id, name: name);
  }

  @override
  Future<void> deleteCategory(String id) async {
    writeCount++;
  }

  TaskEntity _fromInput(String id, TaskInput input) => TaskEntity(
    id: id,
    title: input.title,
    description: input.description,
    categoryId: input.categoryId,
    memberId: input.memberId,
    dueDate: input.dueDate,
    status: input.status,
    priority: input.priority,
    assignedBy: 'Server authenticated manager',
  );
}

class _FixtureMemberRepo implements MemberRepository {
  int readCount = 0;
  @override
  Future<Either<WhateverFailure, List<MemberEntity>>> getMembers() async {
    readCount++;
    return const Right([]);
  }

  @override
  Future<Either<WhateverFailure, MemberEntity>> addMember({
    required String email,
    required String role,
  }) async => throw StateError('Not used by task tests');
  @override
  Future<Either<WhateverFailure, void>> updateMemberRole({
    required String memberId,
    required String role,
  }) async => throw StateError('Not used by task tests');
}
