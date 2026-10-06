import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/employee_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/employee_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/employee/employee_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeRemoteDataSource remoteDataSource;

  EmployeeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<WhateverFailure, List<EmployeeEntity>>> getEmployees() async {
    try {
      return Right(await remoteDataSource.getEmployees());
    } catch (_) {
      return Left(WhateverFailure.serverError());
    }
  }

  @override
  Future<Either<WhateverFailure, EmployeeEntity>> createEmployee(
    EmployeeInput input,
  ) async {
    try {
      return Right(await remoteDataSource.createEmployee(input));
    } catch (_) {
      return Left(WhateverFailure.serverError());
    }
  }

  @override
  Future<Either<WhateverFailure, EmployeeEntity>> updateEmployee(
    String employeeId,
    EmployeeInput input,
  ) async {
    try {
      return Right(
        await remoteDataSource.updateEmployee(employeeId, input),
      );
    } catch (_) {
      return Left(WhateverFailure.serverError());
    }
  }

  @override
  Future<Either<WhateverFailure, void>> deleteEmployee(
    String employeeId,
  ) async {
    try {
      await remoteDataSource.deleteEmployee(employeeId);
      return const Right(null);
    } catch (_) {
      return Left(WhateverFailure.serverError());
    }
  }
}
