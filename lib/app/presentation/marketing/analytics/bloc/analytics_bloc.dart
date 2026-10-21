import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:optima_sync_v2/app/domain/entities/marketing/analytics_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/marketing/campaign_entity.dart';
import 'package:optima_sync_v2/app/domain/usecases/marketing/analytics_usecases.dart';
import 'package:optima_sync_v2/core/errors/marketing/marketing_errors.dart';

part 'analytics_bloc.freezed.dart';
part 'analytics_event.dart';
part 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final AnalyticsUsecases usecases;

  AnalyticsBloc({required this.usecases}) : super(.initial()) {
    on<AnalyticsEvent>((event, emit) async {
      await event.when(
        loadDashboard: () => _onLoadDashboard(emit),
        loadCampaignAnalytics: (campaign) => _onLoadCampaignAnalytics(campaign, emit),
      );
    });
  }

  Future<void> _onLoadDashboard(Emitter<AnalyticsState> emit) async {
    emit(.loading());

    final dashboardResult = await usecases.getDashboard();

    await dashboardResult.fold((failure) async => emit(.failure(failure: failure)), (dashboard) async {
      final campaignsResult = await usecases.getEffectiveCampaigns();

      campaignsResult.fold(
        (failure) => emit(.failure(failure: failure)),
        (effectiveCampaigns) => emit(.dashboardLoaded(dashboard: dashboard, effectiveCampaigns: effectiveCampaigns)),
      );
    });
  }

  Future<void> _onLoadCampaignAnalytics(CampaignEntity campaign, Emitter<AnalyticsState> emit) async {
    emit(.loading());

    final result = await usecases.getCampaignAnalytics(campaign);

    result.fold(
      (failure) => emit(.failure(failure: failure)),
      (analytics) => emit(.campaignAnalyticsLoaded(analytics: analytics)),
    );
  }
}
