import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/usecases/public_capture_usecases.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

import 'public_capture_event.dart';
import 'public_capture_state.dart';

class PublicCaptureBloc extends Bloc<PublicCaptureEvent, PublicCaptureState> {
  final PublicCaptureUsecases usecases;

  PublicCaptureBloc({required this.usecases}) : super(PublicCaptureInitial()) {
    on<LoadPublicCaptureForm>(_onLoad);
    on<SubmitPublicCaptureForm>(_onSubmit);
  }

  Future<void> _onLoad(
    LoadPublicCaptureForm event,
    Emitter<PublicCaptureState> emit,
  ) async {
    emit(PublicCaptureLoading());

    final result = await usecases.getForm(event.token);

    result.fold(
      (failure) => emit(PublicCaptureFailure(message: _messageFor(failure))),
      (form) => emit(PublicCaptureLoaded(form: form)),
    );
  }

  Future<void> _onSubmit(
    SubmitPublicCaptureForm event,
    Emitter<PublicCaptureState> emit,
  ) async {
    final currentState = state;
    if (currentState is PublicCaptureLoaded) {
      emit(PublicCaptureSubmitting(form: currentState.form));
    }

    final result = await usecases.submitForm(token: event.token, data: event.data);

    result.fold(
      (failure) => emit(PublicCaptureFailure(message: _messageFor(failure))),
      (_) => emit(PublicCaptureSubmitted()),
    );
  }

  String _messageFor(WhateverFailure failure) {
    return failure.when(
      serverError: () => 'Server error, please try again',
      whatoffline: () => 'No internet connection',
      database: () => 'Something went wrong, please try again',
    );
  }
}
