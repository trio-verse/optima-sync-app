import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/content_entity.dart';
import 'package:optima_sync_v2/app/domain/usecases/content_usecases.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

import 'content_event.dart';
import 'content_state.dart';

class ContentBloc extends Bloc<ContentEvent, ContentState> {
  final ContentUsecases usecases;

  ContentBloc({required this.usecases}) : super(ContentInitial()) {
    on<LoadContents>(_onLoadContents);
    on<AddContentSubmitted>(_onAddContentSubmitted);
    on<UpdateContentSubmitted>(_onUpdateContentSubmitted);
    on<ContentStatusChanged>(_onContentStatusChanged);
    on<DeleteContentSubmitted>(_onDeleteContentSubmitted);
  }

  List<ContentEntity> _currentContents() {
    final currentState = state;
    if (currentState is ContentSuccess) return currentState.contents;
    if (currentState is ContentSubmitting) return currentState.contents;
    if (currentState is ContentFailure)
      return currentState.contents ?? const [];
    return const [];
  }

  Future<void> _onLoadContents(
    LoadContents event,
    Emitter<ContentState> emit,
  ) async {
    emit(ContentLoading());

    final result = await usecases.getCampaignContents(event.campaignId);

    result.fold(
      (failure) => emit(ContentFailure(message: _messageFor(failure))),
      (contents) => emit(ContentSuccess(contents: contents)),
    );
  }

  Future<void> _onAddContentSubmitted(
    AddContentSubmitted event,
    Emitter<ContentState> emit,
  ) async {
    final existing = _currentContents();

    emit(ContentSubmitting(contents: existing));

    if (event.content.title.trim().isEmpty) {
      emit(ContentFailure(message: 'Title is required', contents: existing));
      return;
    }

    if (event.content.type.trim().isEmpty) {
      emit(ContentFailure(message: 'Type is required', contents: existing));
      return;
    }

    if (event.content.channelId.trim().isEmpty) {
      emit(ContentFailure(message: 'Channel is required', contents: existing));
      return;
    }

    final createResult = await usecases.createContent(
      campaignId: event.campaignId,
      content: event.content,
    );

    await createResult.fold(
      (failure) async => emit(
        ContentFailure(message: _messageFor(failure), contents: existing),
      ),
      (created) async {
        final refreshResult = await usecases.getCampaignContents(
          event.campaignId,
        );

        final contents = refreshResult.fold(
          (_) => [created, ...existing],
          (list) => list,
        );

        emit(ContentSuccess(contents: contents, message: 'Content created'));
      },
    );
  }

  Future<void> _onUpdateContentSubmitted(
    UpdateContentSubmitted event,
    Emitter<ContentState> emit,
  ) async {
    final existing = _currentContents();

    emit(ContentSubmitting(contents: existing));

    if (event.content.title.trim().isEmpty) {
      emit(ContentFailure(message: 'Title is required', contents: existing));
      return;
    }

    final updateResult = await usecases.updateContent(
      campaignId: event.campaignId,
      id: event.id,
      content: event.content,
    );

    await updateResult.fold(
      (failure) async => emit(
        ContentFailure(message: _messageFor(failure), contents: existing),
      ),
      (updated) async {
        final refreshResult = await usecases.getCampaignContents(
          event.campaignId,
        );

        final contents = refreshResult.fold(
          (_) => [
            for (final c in existing)
              if (c.id == updated.id) updated else c,
          ],
          (list) => list,
        );

        emit(ContentSuccess(contents: contents, message: 'Content updated'));
      },
    );
  }

  Future<void> _onContentStatusChanged(
    ContentStatusChanged event,
    Emitter<ContentState> emit,
  ) async {
    final existing = _currentContents();

    final optimistic = [
      for (final c in existing)
        if (c.id == event.id) c.copyWith(status: event.newStatus) else c,
    ];

    emit(ContentSubmitting(contents: optimistic));

    final result = await usecases.updateContent(
      campaignId: event.campaignId,
      id: event.id,
      content: event.content.copyWith(status: event.newStatus),
    );

    result.fold(
      (failure) => emit(
        ContentFailure(message: _messageFor(failure), contents: existing),
      ),
      (updated) {
        final contents = [
          for (final c in existing)
            if (c.id == updated.id) updated else c,
        ];
        emit(ContentSuccess(contents: contents));
      },
    );
  }

  Future<void> _onDeleteContentSubmitted(
    DeleteContentSubmitted event,
    Emitter<ContentState> emit,
  ) async {
    final existing = _currentContents();

    emit(ContentSubmitting(contents: existing));

    final result = await usecases.deleteContent(
      campaignId: event.campaignId,
      id: event.id,
    );

    result.fold(
      (failure) => emit(
        ContentFailure(message: _messageFor(failure), contents: existing),
      ),
      (_) {
        final updatedContents = existing
            .where((content) => content.id != event.id)
            .toList();
        emit(
          ContentSuccess(contents: updatedContents, message: 'Content deleted'),
        );
      },
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
