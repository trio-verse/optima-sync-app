import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/campaign_entity.dart';
import 'package:optima_sync_v2/app/domain/usecases/campaign_usecases.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

import 'campaign_event.dart';
import 'campaign_state.dart';

class CampaignBloc extends Bloc<CampaignEvent, CampaignState> {
  final CampaignUsecases usecases;

  CampaignBloc({required this.usecases}) : super(CampaignInitial()) {
    on<LoadCampaigns>(_onLoadCampaigns);
    on<AddCampaignSubmitted>(_onAddCampaignSubmitted);
    on<UpdateCampaignSubmitted>(_onUpdateCampaignSubmitted);
    on<DeleteCampaignSubmitted>(_onDeleteCampaignSubmitted);
  }

  Future<void> _onLoadCampaigns(
    LoadCampaigns event,
    Emitter<CampaignState> emit,
  ) async {
    emit(CampaignLoading());

    final result = await usecases.getCampaigns();

    result.fold(
      (failure) => emit(CampaignFailure(message: _messageFor(failure))),
      (campaigns) => emit(CampaignSuccess(campaigns: campaigns)),
    );
  }

  Future<void> _onAddCampaignSubmitted(
    AddCampaignSubmitted event,
    Emitter<CampaignState> emit,
  ) async {
    final previousCampaigns = _currentCampaigns();
    emit(CampaignLoading());

    final createResult = await usecases.createCampaign(event.campaign);

    await createResult.fold(
      (failure) async => emit(CampaignFailure(message: _messageFor(failure))),
      (created) async {
        final refreshResult = await usecases.getCampaigns();

        final campaigns = refreshResult.fold((_) {
          return [...previousCampaigns, created];
        }, (list) => list);

        emit(CampaignSuccess(campaigns: campaigns));
      },
    );
  }

  Future<void> _onUpdateCampaignSubmitted(
    UpdateCampaignSubmitted event,
    Emitter<CampaignState> emit,
  ) async {
    final previousCampaigns = _currentCampaigns();
    emit(CampaignLoading());

    final updateResult = await usecases.updateCampaign(
      id: event.id,
      campaign: event.campaign,
    );

    await updateResult.fold(
      (failure) async => emit(CampaignFailure(message: _messageFor(failure))),
      (updated) async {
        final refreshResult = await usecases.getCampaigns();

        final campaigns = refreshResult.fold((_) {
        
          return [
            for (final c in previousCampaigns)
              if (c.id == updated.id) updated else c,
          ];
        }, (list) => list);

        emit(CampaignSuccess(campaigns: campaigns));
      },
    );
  }

  Future<void> _onDeleteCampaignSubmitted(
    DeleteCampaignSubmitted event,
    Emitter<CampaignState> emit,
  ) async {
    final currentState = state;

    if (currentState is! CampaignSuccess) {
      return;
    }

    emit(CampaignLoading());

    final result = await usecases.deleteCampaign(event.id);

    result.fold(
      (failure) => emit(CampaignFailure(message: _messageFor(failure))),
      (_) {
        final updatedCampaigns = currentState.campaigns
            .where((campaign) => campaign.id != event.id)
            .toList();
        emit(CampaignSuccess(campaigns: updatedCampaigns));
      },
    );
  }

  List<CampaignEntity> _currentCampaigns() {
    final current = state;
    if (current is CampaignSuccess) return current.campaigns;
    if (current is CampaignFailure) return current.campaigns ?? const [];
    return const [];
  }

  String _messageFor(WhateverFailure failure) {
    return failure.when(
      serverError: () => 'Server error, please try again',
      whatoffline: () => 'No internet connection',
      database: () => 'Something went wrong, please try again',
    );
  }
}
