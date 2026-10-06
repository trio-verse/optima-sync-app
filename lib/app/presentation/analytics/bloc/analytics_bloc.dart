import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/usecases/analytics_usecases.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

import 'analytics_event.dart';
import 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final AnalyticsUsecases usecases;

  AnalyticsBloc({required this.usecases}) : super(AnalyticsInitial()) {
    on<LoadMarketingDashboard>(_onLoadDashboard);
    on<LoadCampaignAnalytics>(_onLoadCampaignAnalytics);
  }

  Future<void> _onLoadDashboard(
    LoadMarketingDashboard event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());

    final dashboardResult = await usecases.getDashboard();

    await dashboardResult.fold(
      (failure) async =>
          emit(AnalyticsFailure(message: _messageFor(failure))),
      (dashboard) async {
        final campaignsResult = await usecases.getEffectiveCampaigns();

        campaignsResult.fold(
          (failure) => emit(AnalyticsFailure(message: _messageFor(failure))),
          (effectiveCampaigns) => emit(
            MarketingDashboardLoaded(
              dashboard: dashboard,
              effectiveCampaigns: effectiveCampaigns,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onLoadCampaignAnalytics(
    LoadCampaignAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());

    final result = await usecases.getCampaignAnalytics(event.campaignId);

    result.fold(
      (failure) => emit(AnalyticsFailure(message: _messageFor(failure))),
      (analytics) => emit(CampaignAnalyticsLoaded(analytics: analytics)),
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
