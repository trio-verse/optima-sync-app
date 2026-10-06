import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/public_capture_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/public_capture_form_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/public_capture/public_capture_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class PublicCaptureRepositoryImpl implements PublicCaptureRepository {
  final PublicCaptureRemoteDataSource remoteDataSource;

  PublicCaptureRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<WhateverFailure, PublicCaptureFormEntity>> getForm(
    String token,
  ) async {
    try {
      final res = await remoteDataSource.getForm(token);
      print('========== GET FORM RESPONSE ==========');
      print(res);
      print('=======================================');

      return Right(res);
    } catch (e) {
      print('========== GET FORM ERROR ==========');
      print(e);
      print('====================================');

      return Left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<Either<WhateverFailure, void>> submitForm({
    required String token,
    required Map<String, dynamic> data,
  }) async {
    try {
      final res = await remoteDataSource.submitForm(token: token, data: data);
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }
}
