import 'package:freezed_annotation/freezed_annotation.dart';
part 'task_manager_error.freezed.dart';

@freezed
abstract class TaskManagerError with _$TaskManagerError {
  const factory TaskManagerError.offline() = _Offline;
  const factory TaskManagerError.notFound() = _NotFound;
}
