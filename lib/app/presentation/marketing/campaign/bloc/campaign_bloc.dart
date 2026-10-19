import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:optima_sync_v2/app/domain/entities/marketing/campaign_entity.dart';
import 'package:optima_sync_v2/app/domain/usecases/marketing/campaign_usecases.dart';
import 'package:optima_sync_v2/core/errors/failures/failures.dart';
import 'package:optima_sync_v2/core/errors/marketing/marketing_errors.dart';

part 'campaign_bloc.freezed.dart';
part 'campaign_event.dart';
part 'campaign_state.dart';

class CampaignBloc extends Bloc<CampaignEvent, CampaignState> {
  final CampaignUsecases usecases;

  List<CampaignEntity> _campaigns = const [];

  CampaignBloc({required this.usecases}) : super(.initial()) {
    on<CampaignEvent>((event, emit) async {
      await event.when(
        loadCampaigns: () => _onLoadCampaigns(emit),
        addSubmitted: (campaign) => _onAddSubmitted(campaign, emit),
        updateSubmitted: (campaign) => _onUpdateSubmitted(campaign, emit),
        deleteSubmitted: (campaign) => _onDeleteSubmitted(campaign, emit),
      );
    });
  }

  Future<void> _onLoadCampaigns(Emitter<CampaignState> emit) async {
    emit(.loading());

    final result = await usecases.getCampaigns();

    result.fold((failure) => emit(.failure(error: failure)), (campaigns) {
      _campaigns = campaigns;
      emit(.success(campaigns: campaigns));
    });
  }

  Future<void> _onAddSubmitted(
    CampaignEntity campaign,
    Emitter<CampaignState> emit,
  ) async {
    final existing = _campaigns;

    emit(.submitting(campaigns: existing));

    final createResult = await usecases.createCampaign(campaign);

    await createResult.fold((failure) async => emit(.failure(error: failure)), (
      created,
    ) async {
      final refreshResult = await usecases.getCampaigns();

      _campaigns = refreshResult.fold(
        (_) => [...existing, created],
        (list) => list,
      );

      emit(
        .success(
          campaigns: _campaigns,
          successType: CampaignSuccessType.created,
        ),
      );
    });
  }

  Future<void> _onUpdateSubmitted(
    CampaignEntity campaign,
    Emitter<CampaignState> emit,
  ) async {
    final existing = _campaigns;

    emit(.submitting(campaigns: existing));

    final updateResult = await usecases.updateCampaign(campaign);

    await updateResult.fold((failure) async => emit(.failure(error: failure)), (
      updated,
    ) async {
      final refreshResult = await usecases.getCampaigns();

      _campaigns = refreshResult.fold(
        (_) => [
          for (final c in existing)
            if (c.id == updated.id) updated else c,
        ],
        (list) => list,
      );

      emit(
        .success(
          campaigns: _campaigns,
          successType: CampaignSuccessType.updated,
        ),
      );
    });
  }

  Future<void> _onDeleteSubmitted(
    CampaignEntity campaign,
    Emitter<CampaignState> emit,
  ) async {
    final existing = _campaigns;

    emit(.submitting(campaigns: existing));

    final result = await usecases.deleteCampaign(campaign);

    result.fold((failure) => emit(.failure(error: failure)), (_) {
      _campaigns = existing.where((c) => c.id != campaign.id).toList();

      emit(
        .success(
          campaigns: _campaigns,
          successType: CampaignSuccessType.deleted,
        ),
      );
    });
  }
}
