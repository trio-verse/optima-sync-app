// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AnalyticsEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AnalyticsEvent()';
}


}

/// @nodoc
class $AnalyticsEventCopyWith<$Res>  {
$AnalyticsEventCopyWith(AnalyticsEvent _, $Res Function(AnalyticsEvent) __);
}


/// Adds pattern-matching-related methods to [AnalyticsEvent].
extension AnalyticsEventPatterns on AnalyticsEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadMarketingDashboard value)?  loadDashboard,TResult Function( LoadCampaignAnalytics value)?  loadCampaignAnalytics,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadMarketingDashboard() when loadDashboard != null:
return loadDashboard(_that);case LoadCampaignAnalytics() when loadCampaignAnalytics != null:
return loadCampaignAnalytics(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadMarketingDashboard value)  loadDashboard,required TResult Function( LoadCampaignAnalytics value)  loadCampaignAnalytics,}){
final _that = this;
switch (_that) {
case LoadMarketingDashboard():
return loadDashboard(_that);case LoadCampaignAnalytics():
return loadCampaignAnalytics(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadMarketingDashboard value)?  loadDashboard,TResult? Function( LoadCampaignAnalytics value)?  loadCampaignAnalytics,}){
final _that = this;
switch (_that) {
case LoadMarketingDashboard() when loadDashboard != null:
return loadDashboard(_that);case LoadCampaignAnalytics() when loadCampaignAnalytics != null:
return loadCampaignAnalytics(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loadDashboard,TResult Function( CampaignEntity campaign)?  loadCampaignAnalytics,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadMarketingDashboard() when loadDashboard != null:
return loadDashboard();case LoadCampaignAnalytics() when loadCampaignAnalytics != null:
return loadCampaignAnalytics(_that.campaign);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loadDashboard,required TResult Function( CampaignEntity campaign)  loadCampaignAnalytics,}) {final _that = this;
switch (_that) {
case LoadMarketingDashboard():
return loadDashboard();case LoadCampaignAnalytics():
return loadCampaignAnalytics(_that.campaign);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loadDashboard,TResult? Function( CampaignEntity campaign)?  loadCampaignAnalytics,}) {final _that = this;
switch (_that) {
case LoadMarketingDashboard() when loadDashboard != null:
return loadDashboard();case LoadCampaignAnalytics() when loadCampaignAnalytics != null:
return loadCampaignAnalytics(_that.campaign);case _:
  return null;

}
}

}

/// @nodoc


class LoadMarketingDashboard implements AnalyticsEvent {
  const LoadMarketingDashboard();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadMarketingDashboard);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AnalyticsEvent.loadDashboard()';
}


}




/// @nodoc


class LoadCampaignAnalytics implements AnalyticsEvent {
  const LoadCampaignAnalytics({required this.campaign});
  

 final  CampaignEntity campaign;

/// Create a copy of AnalyticsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadCampaignAnalyticsCopyWith<LoadCampaignAnalytics> get copyWith => _$LoadCampaignAnalyticsCopyWithImpl<LoadCampaignAnalytics>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadCampaignAnalytics&&(identical(other.campaign, campaign) || other.campaign == campaign));
}


@override
int get hashCode => Object.hash(runtimeType,campaign);

@override
String toString() {
  return 'AnalyticsEvent.loadCampaignAnalytics(campaign: $campaign)';
}


}

/// @nodoc
abstract mixin class $LoadCampaignAnalyticsCopyWith<$Res> implements $AnalyticsEventCopyWith<$Res> {
  factory $LoadCampaignAnalyticsCopyWith(LoadCampaignAnalytics value, $Res Function(LoadCampaignAnalytics) _then) = _$LoadCampaignAnalyticsCopyWithImpl;
@useResult
$Res call({
 CampaignEntity campaign
});




}
/// @nodoc
class _$LoadCampaignAnalyticsCopyWithImpl<$Res>
    implements $LoadCampaignAnalyticsCopyWith<$Res> {
  _$LoadCampaignAnalyticsCopyWithImpl(this._self, this._then);

  final LoadCampaignAnalytics _self;
  final $Res Function(LoadCampaignAnalytics) _then;

/// Create a copy of AnalyticsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? campaign = null,}) {
  return _then(LoadCampaignAnalytics(
campaign: null == campaign ? _self.campaign : campaign // ignore: cast_nullable_to_non_nullable
as CampaignEntity,
  ));
}


}

/// @nodoc
mixin _$AnalyticsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AnalyticsState()';
}


}

/// @nodoc
class $AnalyticsStateCopyWith<$Res>  {
$AnalyticsStateCopyWith(AnalyticsState _, $Res Function(AnalyticsState) __);
}


/// Adds pattern-matching-related methods to [AnalyticsState].
extension AnalyticsStatePatterns on AnalyticsState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AnalyticsInitial value)?  initial,TResult Function( AnalyticsLoading value)?  loading,TResult Function( MarketingDashboardLoaded value)?  dashboardLoaded,TResult Function( CampaignAnalyticsLoaded value)?  campaignAnalyticsLoaded,TResult Function( AnalyticsFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AnalyticsInitial() when initial != null:
return initial(_that);case AnalyticsLoading() when loading != null:
return loading(_that);case MarketingDashboardLoaded() when dashboardLoaded != null:
return dashboardLoaded(_that);case CampaignAnalyticsLoaded() when campaignAnalyticsLoaded != null:
return campaignAnalyticsLoaded(_that);case AnalyticsFailure() when failure != null:
return failure(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AnalyticsInitial value)  initial,required TResult Function( AnalyticsLoading value)  loading,required TResult Function( MarketingDashboardLoaded value)  dashboardLoaded,required TResult Function( CampaignAnalyticsLoaded value)  campaignAnalyticsLoaded,required TResult Function( AnalyticsFailure value)  failure,}){
final _that = this;
switch (_that) {
case AnalyticsInitial():
return initial(_that);case AnalyticsLoading():
return loading(_that);case MarketingDashboardLoaded():
return dashboardLoaded(_that);case CampaignAnalyticsLoaded():
return campaignAnalyticsLoaded(_that);case AnalyticsFailure():
return failure(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AnalyticsInitial value)?  initial,TResult? Function( AnalyticsLoading value)?  loading,TResult? Function( MarketingDashboardLoaded value)?  dashboardLoaded,TResult? Function( CampaignAnalyticsLoaded value)?  campaignAnalyticsLoaded,TResult? Function( AnalyticsFailure value)?  failure,}){
final _that = this;
switch (_that) {
case AnalyticsInitial() when initial != null:
return initial(_that);case AnalyticsLoading() when loading != null:
return loading(_that);case MarketingDashboardLoaded() when dashboardLoaded != null:
return dashboardLoaded(_that);case CampaignAnalyticsLoaded() when campaignAnalyticsLoaded != null:
return campaignAnalyticsLoaded(_that);case AnalyticsFailure() when failure != null:
return failure(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( MarketingDashboardEntity dashboard,  List<EffectiveCampaignEntity> effectiveCampaigns)?  dashboardLoaded,TResult Function( CampaignAnalyticsEntity analytics)?  campaignAnalyticsLoaded,TResult Function( AnalyticsError failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AnalyticsInitial() when initial != null:
return initial();case AnalyticsLoading() when loading != null:
return loading();case MarketingDashboardLoaded() when dashboardLoaded != null:
return dashboardLoaded(_that.dashboard,_that.effectiveCampaigns);case CampaignAnalyticsLoaded() when campaignAnalyticsLoaded != null:
return campaignAnalyticsLoaded(_that.analytics);case AnalyticsFailure() when failure != null:
return failure(_that.failure);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( MarketingDashboardEntity dashboard,  List<EffectiveCampaignEntity> effectiveCampaigns)  dashboardLoaded,required TResult Function( CampaignAnalyticsEntity analytics)  campaignAnalyticsLoaded,required TResult Function( AnalyticsError failure)  failure,}) {final _that = this;
switch (_that) {
case AnalyticsInitial():
return initial();case AnalyticsLoading():
return loading();case MarketingDashboardLoaded():
return dashboardLoaded(_that.dashboard,_that.effectiveCampaigns);case CampaignAnalyticsLoaded():
return campaignAnalyticsLoaded(_that.analytics);case AnalyticsFailure():
return failure(_that.failure);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( MarketingDashboardEntity dashboard,  List<EffectiveCampaignEntity> effectiveCampaigns)?  dashboardLoaded,TResult? Function( CampaignAnalyticsEntity analytics)?  campaignAnalyticsLoaded,TResult? Function( AnalyticsError failure)?  failure,}) {final _that = this;
switch (_that) {
case AnalyticsInitial() when initial != null:
return initial();case AnalyticsLoading() when loading != null:
return loading();case MarketingDashboardLoaded() when dashboardLoaded != null:
return dashboardLoaded(_that.dashboard,_that.effectiveCampaigns);case CampaignAnalyticsLoaded() when campaignAnalyticsLoaded != null:
return campaignAnalyticsLoaded(_that.analytics);case AnalyticsFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class AnalyticsInitial implements AnalyticsState {
  const AnalyticsInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AnalyticsState.initial()';
}


}




/// @nodoc


class AnalyticsLoading implements AnalyticsState {
  const AnalyticsLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AnalyticsState.loading()';
}


}




/// @nodoc


class MarketingDashboardLoaded implements AnalyticsState {
  const MarketingDashboardLoaded({required this.dashboard, required final  List<EffectiveCampaignEntity> effectiveCampaigns}): _effectiveCampaigns = effectiveCampaigns;
  

 final  MarketingDashboardEntity dashboard;
 final  List<EffectiveCampaignEntity> _effectiveCampaigns;
 List<EffectiveCampaignEntity> get effectiveCampaigns {
  if (_effectiveCampaigns is EqualUnmodifiableListView) return _effectiveCampaigns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_effectiveCampaigns);
}


/// Create a copy of AnalyticsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarketingDashboardLoadedCopyWith<MarketingDashboardLoaded> get copyWith => _$MarketingDashboardLoadedCopyWithImpl<MarketingDashboardLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketingDashboardLoaded&&(identical(other.dashboard, dashboard) || other.dashboard == dashboard)&&const DeepCollectionEquality().equals(other._effectiveCampaigns, _effectiveCampaigns));
}


@override
int get hashCode => Object.hash(runtimeType,dashboard,const DeepCollectionEquality().hash(_effectiveCampaigns));

@override
String toString() {
  return 'AnalyticsState.dashboardLoaded(dashboard: $dashboard, effectiveCampaigns: $effectiveCampaigns)';
}


}

/// @nodoc
abstract mixin class $MarketingDashboardLoadedCopyWith<$Res> implements $AnalyticsStateCopyWith<$Res> {
  factory $MarketingDashboardLoadedCopyWith(MarketingDashboardLoaded value, $Res Function(MarketingDashboardLoaded) _then) = _$MarketingDashboardLoadedCopyWithImpl;
@useResult
$Res call({
 MarketingDashboardEntity dashboard, List<EffectiveCampaignEntity> effectiveCampaigns
});




}
/// @nodoc
class _$MarketingDashboardLoadedCopyWithImpl<$Res>
    implements $MarketingDashboardLoadedCopyWith<$Res> {
  _$MarketingDashboardLoadedCopyWithImpl(this._self, this._then);

  final MarketingDashboardLoaded _self;
  final $Res Function(MarketingDashboardLoaded) _then;

/// Create a copy of AnalyticsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? dashboard = null,Object? effectiveCampaigns = null,}) {
  return _then(MarketingDashboardLoaded(
dashboard: null == dashboard ? _self.dashboard : dashboard // ignore: cast_nullable_to_non_nullable
as MarketingDashboardEntity,effectiveCampaigns: null == effectiveCampaigns ? _self._effectiveCampaigns : effectiveCampaigns // ignore: cast_nullable_to_non_nullable
as List<EffectiveCampaignEntity>,
  ));
}


}

/// @nodoc


class CampaignAnalyticsLoaded implements AnalyticsState {
  const CampaignAnalyticsLoaded({required this.analytics});
  

 final  CampaignAnalyticsEntity analytics;

/// Create a copy of AnalyticsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CampaignAnalyticsLoadedCopyWith<CampaignAnalyticsLoaded> get copyWith => _$CampaignAnalyticsLoadedCopyWithImpl<CampaignAnalyticsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CampaignAnalyticsLoaded&&(identical(other.analytics, analytics) || other.analytics == analytics));
}


@override
int get hashCode => Object.hash(runtimeType,analytics);

@override
String toString() {
  return 'AnalyticsState.campaignAnalyticsLoaded(analytics: $analytics)';
}


}

/// @nodoc
abstract mixin class $CampaignAnalyticsLoadedCopyWith<$Res> implements $AnalyticsStateCopyWith<$Res> {
  factory $CampaignAnalyticsLoadedCopyWith(CampaignAnalyticsLoaded value, $Res Function(CampaignAnalyticsLoaded) _then) = _$CampaignAnalyticsLoadedCopyWithImpl;
@useResult
$Res call({
 CampaignAnalyticsEntity analytics
});




}
/// @nodoc
class _$CampaignAnalyticsLoadedCopyWithImpl<$Res>
    implements $CampaignAnalyticsLoadedCopyWith<$Res> {
  _$CampaignAnalyticsLoadedCopyWithImpl(this._self, this._then);

  final CampaignAnalyticsLoaded _self;
  final $Res Function(CampaignAnalyticsLoaded) _then;

/// Create a copy of AnalyticsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? analytics = null,}) {
  return _then(CampaignAnalyticsLoaded(
analytics: null == analytics ? _self.analytics : analytics // ignore: cast_nullable_to_non_nullable
as CampaignAnalyticsEntity,
  ));
}


}

/// @nodoc


class AnalyticsFailure implements AnalyticsState {
  const AnalyticsFailure({required this.failure});
  

 final  AnalyticsError failure;

/// Create a copy of AnalyticsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsFailureCopyWith<AnalyticsFailure> get copyWith => _$AnalyticsFailureCopyWithImpl<AnalyticsFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'AnalyticsState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $AnalyticsFailureCopyWith<$Res> implements $AnalyticsStateCopyWith<$Res> {
  factory $AnalyticsFailureCopyWith(AnalyticsFailure value, $Res Function(AnalyticsFailure) _then) = _$AnalyticsFailureCopyWithImpl;
@useResult
$Res call({
 AnalyticsError failure
});


$AnalyticsErrorCopyWith<$Res> get failure;

}
/// @nodoc
class _$AnalyticsFailureCopyWithImpl<$Res>
    implements $AnalyticsFailureCopyWith<$Res> {
  _$AnalyticsFailureCopyWithImpl(this._self, this._then);

  final AnalyticsFailure _self;
  final $Res Function(AnalyticsFailure) _then;

/// Create a copy of AnalyticsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(AnalyticsFailure(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AnalyticsError,
  ));
}

/// Create a copy of AnalyticsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsErrorCopyWith<$Res> get failure {
  
  return $AnalyticsErrorCopyWith<$Res>(_self.failure, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on
