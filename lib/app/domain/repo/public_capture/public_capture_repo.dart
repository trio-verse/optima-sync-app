import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/public_capture_form_entity.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

abstract class PublicCaptureRepository {
  Future<Either<WhateverFailure, PublicCaptureFormEntity>> getForm(String token);

  Future<Either<WhateverFailure, void>> submitForm({
    required String token,
    required Map<String, dynamic> data,
  });
}
