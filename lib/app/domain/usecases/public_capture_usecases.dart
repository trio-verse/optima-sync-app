import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/public_capture_form_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/public_capture/public_capture_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class PublicCaptureUsecases {
  final PublicCaptureRepository repo;

  PublicCaptureUsecases({required this.repo});

  Future<Either<WhateverFailure, PublicCaptureFormEntity>> getForm(String token) {
    return repo.getForm(token);
  }

  Future<Either<WhateverFailure, void>> submitForm({
    required String token,
    required Map<String, dynamic> data,
  }) {
    return repo.submitForm(token: token, data: data);
  }
}
