import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/usecases/capture_usecases.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

import 'capture_event.dart';
import 'capture_state.dart';

class CaptureBloc extends Bloc<CaptureEvent, CaptureState> {
  final CaptureUsecases usecases;

  CaptureBloc({required this.usecases}) : super(CaptureInitial()) {
    on<LoadCaptureSettings>(_onLoad);
    on<ToggleCaptureSubmitted>(_onToggle);
    on<RegenerateTokenSubmitted>(_onRegenerate);
  }

  Future<void> _onLoad(
    LoadCaptureSettings event,
    Emitter<CaptureState> emit,
  ) async {
    emit(CaptureLoading());

    final result = await usecases.getCaptureSettings(event.campaignId);

    result.fold(
      (failure) => emit(CaptureFailure(message: _messageFor(failure))),
      (settings) => emit(CaptureSuccess(settings: settings)),
    );
  }

  Future<void> _onToggle(
    ToggleCaptureSubmitted event,
    Emitter<CaptureState> emit,
  ) async {
    final currentState = state;
    if (currentState is CaptureSuccess) {
      emit(CaptureSubmitting(settings: currentState.settings));
    } else {
      emit(CaptureLoading());
    }

    final result = await usecases.setCaptureEnabled(
      campaignId: event.campaignId,
      enabled: event.enabled,
    );

    result.fold(
      (failure) => emit(
        CaptureFailure(
          message: _messageFor(failure),
          settings: currentState is CaptureSuccess ? currentState.settings : null,
        ),
      ),
      (settings) => emit(
        CaptureSuccess(
          settings: settings,
          message: event.enabled ? 'Capture form enabled' : 'Capture form disabled',
        ),
      ),
    );
  }

  Future<void> _onRegenerate(
    RegenerateTokenSubmitted event,
    Emitter<CaptureState> emit,
  ) async {
    final currentState = state;
    if (currentState is CaptureSuccess) {
      emit(CaptureSubmitting(settings: currentState.settings));
    } else {
      emit(CaptureLoading());
    }

    final result = await usecases.regenerateToken(event.campaignId);

    result.fold(
      (failure) => emit(
        CaptureFailure(
          message: _messageFor(failure),
          settings: currentState is CaptureSuccess ? currentState.settings : null,
        ),
      ),
      (settings) => emit(CaptureSuccess(settings: settings, message: 'Link regenerated')),
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
