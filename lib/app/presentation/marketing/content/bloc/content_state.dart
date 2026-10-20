part of 'content_bloc.dart';

@freezed
class ContentState with _$ContentState {
  const factory ContentState.initial() = _Initial;
  const factory ContentState.loading() = _Loading;
  const factory ContentState.success({required List<ContentEntity> contents, String? message}) = _Success;
  const factory ContentState.failure({required MarketingError failure}) = _Failure;
}
