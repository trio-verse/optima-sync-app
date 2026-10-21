import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:optima_sync_v2/app/domain/entities/marketing/content_entity.dart';
import 'package:optima_sync_v2/app/domain/usecases/marketing/content_usecases.dart';
import 'package:optima_sync_v2/core/errors/marketing/marketing_errors.dart';

part 'content_event.dart';
part 'content_state.dart';
part 'content_bloc.freezed.dart';

class ContentBloc extends Bloc<ContentEvent, ContentState> {
  final ContentUsecases usecases;
  ContentBloc({required this.usecases}) : super(_Initial()) {
    on<ContentEvent>((event, emit) async {
      await event.when(
        getAllCampaignContents: (campaignId) => _onLoadContents(campaignId, emit),
        addCampaignContent: (content) => _onAddSubmitted(content, emit),
        updateCampaignContent: (content) => _onUpdateSubmitted(content, emit),

        deleteCampaignContent: (content) => _onDeleteSubmitted(content, emit),
      );
    });
  }

  Future<void> _onLoadContents(String campaignId, Emitter<ContentState> emit) async {
    emit(.loading());

    final result = await usecases.getCampaignContents(campaignId);

    result.fold((failure) => emit(.failure(failure: failure)), (contents) {
      emit(.success(contents: contents));
    });
  }

  Future<void> _onAddSubmitted(ContentEntity content, Emitter<ContentState> emit) async {
    emit(.loading());

    final createResult = await usecases.createContent(content);

    await createResult.fold((failure) async => emit(.failure(failure: failure)), (created) async {
      add(.getAllCampaignContents(campaignId: content.campaignId));
    });
  }

  Future<void> _onUpdateSubmitted(ContentEntity content, Emitter<ContentState> emit) async {
    emit(.loading());

    final updateResult = await usecases.updateContent(content);

    await updateResult.fold((failure) async => emit(.failure(failure: failure)), (updated) async {
      add(.getAllCampaignContents(campaignId: content.campaignId));
    });
  }

  Future<void> _onDeleteSubmitted(ContentEntity content, Emitter<ContentState> emit) async {
    emit(.loading());

    final result = await usecases.deleteContent(content);

    result.fold((failure) => emit(.failure(failure: failure)), (_) {
      add(.getAllCampaignContents(campaignId: content.campaignId));
    });
  }
}
