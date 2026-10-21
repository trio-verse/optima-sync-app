// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'campaign_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CampaignEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CampaignEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CampaignEvent()';
}


}

/// @nodoc
class $CampaignEventCopyWith<$Res>  {
$CampaignEventCopyWith(CampaignEvent _, $Res Function(CampaignEvent) __);
}


/// Adds pattern-matching-related methods to [CampaignEvent].
extension CampaignEventPatterns on CampaignEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadCampaigns value)?  loadCampaigns,TResult Function( AddCampaignSubmitted value)?  addSubmitted,TResult Function( UpdateCampaignSubmitted value)?  updateSubmitted,TResult Function( DeleteCampaignSubmitted value)?  deleteSubmitted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadCampaigns() when loadCampaigns != null:
return loadCampaigns(_that);case AddCampaignSubmitted() when addSubmitted != null:
return addSubmitted(_that);case UpdateCampaignSubmitted() when updateSubmitted != null:
return updateSubmitted(_that);case DeleteCampaignSubmitted() when deleteSubmitted != null:
return deleteSubmitted(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadCampaigns value)  loadCampaigns,required TResult Function( AddCampaignSubmitted value)  addSubmitted,required TResult Function( UpdateCampaignSubmitted value)  updateSubmitted,required TResult Function( DeleteCampaignSubmitted value)  deleteSubmitted,}){
final _that = this;
switch (_that) {
case LoadCampaigns():
return loadCampaigns(_that);case AddCampaignSubmitted():
return addSubmitted(_that);case UpdateCampaignSubmitted():
return updateSubmitted(_that);case DeleteCampaignSubmitted():
return deleteSubmitted(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadCampaigns value)?  loadCampaigns,TResult? Function( AddCampaignSubmitted value)?  addSubmitted,TResult? Function( UpdateCampaignSubmitted value)?  updateSubmitted,TResult? Function( DeleteCampaignSubmitted value)?  deleteSubmitted,}){
final _that = this;
switch (_that) {
case LoadCampaigns() when loadCampaigns != null:
return loadCampaigns(_that);case AddCampaignSubmitted() when addSubmitted != null:
return addSubmitted(_that);case UpdateCampaignSubmitted() when updateSubmitted != null:
return updateSubmitted(_that);case DeleteCampaignSubmitted() when deleteSubmitted != null:
return deleteSubmitted(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loadCampaigns,TResult Function( CampaignEntity campaign)?  addSubmitted,TResult Function( CampaignEntity campaign)?  updateSubmitted,TResult Function( CampaignEntity campaign)?  deleteSubmitted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadCampaigns() when loadCampaigns != null:
return loadCampaigns();case AddCampaignSubmitted() when addSubmitted != null:
return addSubmitted(_that.campaign);case UpdateCampaignSubmitted() when updateSubmitted != null:
return updateSubmitted(_that.campaign);case DeleteCampaignSubmitted() when deleteSubmitted != null:
return deleteSubmitted(_that.campaign);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loadCampaigns,required TResult Function( CampaignEntity campaign)  addSubmitted,required TResult Function( CampaignEntity campaign)  updateSubmitted,required TResult Function( CampaignEntity campaign)  deleteSubmitted,}) {final _that = this;
switch (_that) {
case LoadCampaigns():
return loadCampaigns();case AddCampaignSubmitted():
return addSubmitted(_that.campaign);case UpdateCampaignSubmitted():
return updateSubmitted(_that.campaign);case DeleteCampaignSubmitted():
return deleteSubmitted(_that.campaign);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loadCampaigns,TResult? Function( CampaignEntity campaign)?  addSubmitted,TResult? Function( CampaignEntity campaign)?  updateSubmitted,TResult? Function( CampaignEntity campaign)?  deleteSubmitted,}) {final _that = this;
switch (_that) {
case LoadCampaigns() when loadCampaigns != null:
return loadCampaigns();case AddCampaignSubmitted() when addSubmitted != null:
return addSubmitted(_that.campaign);case UpdateCampaignSubmitted() when updateSubmitted != null:
return updateSubmitted(_that.campaign);case DeleteCampaignSubmitted() when deleteSubmitted != null:
return deleteSubmitted(_that.campaign);case _:
  return null;

}
}

}

/// @nodoc


class LoadCampaigns implements CampaignEvent {
  const LoadCampaigns();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadCampaigns);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CampaignEvent.loadCampaigns()';
}


}




/// @nodoc


class AddCampaignSubmitted implements CampaignEvent {
  const AddCampaignSubmitted({required this.campaign});
  

 final  CampaignEntity campaign;

/// Create a copy of CampaignEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddCampaignSubmittedCopyWith<AddCampaignSubmitted> get copyWith => _$AddCampaignSubmittedCopyWithImpl<AddCampaignSubmitted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddCampaignSubmitted&&(identical(other.campaign, campaign) || other.campaign == campaign));
}


@override
int get hashCode => Object.hash(runtimeType,campaign);

@override
String toString() {
  return 'CampaignEvent.addSubmitted(campaign: $campaign)';
}


}

/// @nodoc
abstract mixin class $AddCampaignSubmittedCopyWith<$Res> implements $CampaignEventCopyWith<$Res> {
  factory $AddCampaignSubmittedCopyWith(AddCampaignSubmitted value, $Res Function(AddCampaignSubmitted) _then) = _$AddCampaignSubmittedCopyWithImpl;
@useResult
$Res call({
 CampaignEntity campaign
});




}
/// @nodoc
class _$AddCampaignSubmittedCopyWithImpl<$Res>
    implements $AddCampaignSubmittedCopyWith<$Res> {
  _$AddCampaignSubmittedCopyWithImpl(this._self, this._then);

  final AddCampaignSubmitted _self;
  final $Res Function(AddCampaignSubmitted) _then;

/// Create a copy of CampaignEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? campaign = null,}) {
  return _then(AddCampaignSubmitted(
campaign: null == campaign ? _self.campaign : campaign // ignore: cast_nullable_to_non_nullable
as CampaignEntity,
  ));
}


}

/// @nodoc


class UpdateCampaignSubmitted implements CampaignEvent {
  const UpdateCampaignSubmitted({required this.campaign});
  

 final  CampaignEntity campaign;

/// Create a copy of CampaignEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateCampaignSubmittedCopyWith<UpdateCampaignSubmitted> get copyWith => _$UpdateCampaignSubmittedCopyWithImpl<UpdateCampaignSubmitted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateCampaignSubmitted&&(identical(other.campaign, campaign) || other.campaign == campaign));
}


@override
int get hashCode => Object.hash(runtimeType,campaign);

@override
String toString() {
  return 'CampaignEvent.updateSubmitted(campaign: $campaign)';
}


}

/// @nodoc
abstract mixin class $UpdateCampaignSubmittedCopyWith<$Res> implements $CampaignEventCopyWith<$Res> {
  factory $UpdateCampaignSubmittedCopyWith(UpdateCampaignSubmitted value, $Res Function(UpdateCampaignSubmitted) _then) = _$UpdateCampaignSubmittedCopyWithImpl;
@useResult
$Res call({
 CampaignEntity campaign
});




}
/// @nodoc
class _$UpdateCampaignSubmittedCopyWithImpl<$Res>
    implements $UpdateCampaignSubmittedCopyWith<$Res> {
  _$UpdateCampaignSubmittedCopyWithImpl(this._self, this._then);

  final UpdateCampaignSubmitted _self;
  final $Res Function(UpdateCampaignSubmitted) _then;

/// Create a copy of CampaignEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? campaign = null,}) {
  return _then(UpdateCampaignSubmitted(
campaign: null == campaign ? _self.campaign : campaign // ignore: cast_nullable_to_non_nullable
as CampaignEntity,
  ));
}


}

/// @nodoc


class DeleteCampaignSubmitted implements CampaignEvent {
  const DeleteCampaignSubmitted({required this.campaign});
  

 final  CampaignEntity campaign;

/// Create a copy of CampaignEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeleteCampaignSubmittedCopyWith<DeleteCampaignSubmitted> get copyWith => _$DeleteCampaignSubmittedCopyWithImpl<DeleteCampaignSubmitted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteCampaignSubmitted&&(identical(other.campaign, campaign) || other.campaign == campaign));
}


@override
int get hashCode => Object.hash(runtimeType,campaign);

@override
String toString() {
  return 'CampaignEvent.deleteSubmitted(campaign: $campaign)';
}


}

/// @nodoc
abstract mixin class $DeleteCampaignSubmittedCopyWith<$Res> implements $CampaignEventCopyWith<$Res> {
  factory $DeleteCampaignSubmittedCopyWith(DeleteCampaignSubmitted value, $Res Function(DeleteCampaignSubmitted) _then) = _$DeleteCampaignSubmittedCopyWithImpl;
@useResult
$Res call({
 CampaignEntity campaign
});




}
/// @nodoc
class _$DeleteCampaignSubmittedCopyWithImpl<$Res>
    implements $DeleteCampaignSubmittedCopyWith<$Res> {
  _$DeleteCampaignSubmittedCopyWithImpl(this._self, this._then);

  final DeleteCampaignSubmitted _self;
  final $Res Function(DeleteCampaignSubmitted) _then;

/// Create a copy of CampaignEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? campaign = null,}) {
  return _then(DeleteCampaignSubmitted(
campaign: null == campaign ? _self.campaign : campaign // ignore: cast_nullable_to_non_nullable
as CampaignEntity,
  ));
}


}

/// @nodoc
mixin _$CampaignState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CampaignState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CampaignState()';
}


}

/// @nodoc
class $CampaignStateCopyWith<$Res>  {
$CampaignStateCopyWith(CampaignState _, $Res Function(CampaignState) __);
}


/// Adds pattern-matching-related methods to [CampaignState].
extension CampaignStatePatterns on CampaignState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CampaignInitial value)?  initial,TResult Function( CampaignLoading value)?  loading,TResult Function( CampaignSubmitting value)?  submitting,TResult Function( CampaignSuccess value)?  success,TResult Function( CampaignFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CampaignInitial() when initial != null:
return initial(_that);case CampaignLoading() when loading != null:
return loading(_that);case CampaignSubmitting() when submitting != null:
return submitting(_that);case CampaignSuccess() when success != null:
return success(_that);case CampaignFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CampaignInitial value)  initial,required TResult Function( CampaignLoading value)  loading,required TResult Function( CampaignSubmitting value)  submitting,required TResult Function( CampaignSuccess value)  success,required TResult Function( CampaignFailure value)  failure,}){
final _that = this;
switch (_that) {
case CampaignInitial():
return initial(_that);case CampaignLoading():
return loading(_that);case CampaignSubmitting():
return submitting(_that);case CampaignSuccess():
return success(_that);case CampaignFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CampaignInitial value)?  initial,TResult? Function( CampaignLoading value)?  loading,TResult? Function( CampaignSubmitting value)?  submitting,TResult? Function( CampaignSuccess value)?  success,TResult? Function( CampaignFailure value)?  failure,}){
final _that = this;
switch (_that) {
case CampaignInitial() when initial != null:
return initial(_that);case CampaignLoading() when loading != null:
return loading(_that);case CampaignSubmitting() when submitting != null:
return submitting(_that);case CampaignSuccess() when success != null:
return success(_that);case CampaignFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<CampaignEntity> campaigns)?  submitting,TResult Function( List<CampaignEntity> campaigns,  CampaignSuccessType? successType)?  success,TResult Function( CampaignError error)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CampaignInitial() when initial != null:
return initial();case CampaignLoading() when loading != null:
return loading();case CampaignSubmitting() when submitting != null:
return submitting(_that.campaigns);case CampaignSuccess() when success != null:
return success(_that.campaigns,_that.successType);case CampaignFailure() when failure != null:
return failure(_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<CampaignEntity> campaigns)  submitting,required TResult Function( List<CampaignEntity> campaigns,  CampaignSuccessType? successType)  success,required TResult Function( CampaignError error)  failure,}) {final _that = this;
switch (_that) {
case CampaignInitial():
return initial();case CampaignLoading():
return loading();case CampaignSubmitting():
return submitting(_that.campaigns);case CampaignSuccess():
return success(_that.campaigns,_that.successType);case CampaignFailure():
return failure(_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<CampaignEntity> campaigns)?  submitting,TResult? Function( List<CampaignEntity> campaigns,  CampaignSuccessType? successType)?  success,TResult? Function( CampaignError error)?  failure,}) {final _that = this;
switch (_that) {
case CampaignInitial() when initial != null:
return initial();case CampaignLoading() when loading != null:
return loading();case CampaignSubmitting() when submitting != null:
return submitting(_that.campaigns);case CampaignSuccess() when success != null:
return success(_that.campaigns,_that.successType);case CampaignFailure() when failure != null:
return failure(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class CampaignInitial implements CampaignState {
  const CampaignInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CampaignInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CampaignState.initial()';
}


}




/// @nodoc


class CampaignLoading implements CampaignState {
  const CampaignLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CampaignLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CampaignState.loading()';
}


}




/// @nodoc


class CampaignSubmitting implements CampaignState {
  const CampaignSubmitting({required final  List<CampaignEntity> campaigns}): _campaigns = campaigns;
  

 final  List<CampaignEntity> _campaigns;
 List<CampaignEntity> get campaigns {
  if (_campaigns is EqualUnmodifiableListView) return _campaigns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_campaigns);
}


/// Create a copy of CampaignState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CampaignSubmittingCopyWith<CampaignSubmitting> get copyWith => _$CampaignSubmittingCopyWithImpl<CampaignSubmitting>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CampaignSubmitting&&const DeepCollectionEquality().equals(other._campaigns, _campaigns));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_campaigns));

@override
String toString() {
  return 'CampaignState.submitting(campaigns: $campaigns)';
}


}

/// @nodoc
abstract mixin class $CampaignSubmittingCopyWith<$Res> implements $CampaignStateCopyWith<$Res> {
  factory $CampaignSubmittingCopyWith(CampaignSubmitting value, $Res Function(CampaignSubmitting) _then) = _$CampaignSubmittingCopyWithImpl;
@useResult
$Res call({
 List<CampaignEntity> campaigns
});




}
/// @nodoc
class _$CampaignSubmittingCopyWithImpl<$Res>
    implements $CampaignSubmittingCopyWith<$Res> {
  _$CampaignSubmittingCopyWithImpl(this._self, this._then);

  final CampaignSubmitting _self;
  final $Res Function(CampaignSubmitting) _then;

/// Create a copy of CampaignState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? campaigns = null,}) {
  return _then(CampaignSubmitting(
campaigns: null == campaigns ? _self._campaigns : campaigns // ignore: cast_nullable_to_non_nullable
as List<CampaignEntity>,
  ));
}


}

/// @nodoc


class CampaignSuccess implements CampaignState {
  const CampaignSuccess({required final  List<CampaignEntity> campaigns, this.successType}): _campaigns = campaigns;
  

 final  List<CampaignEntity> _campaigns;
 List<CampaignEntity> get campaigns {
  if (_campaigns is EqualUnmodifiableListView) return _campaigns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_campaigns);
}

 final  CampaignSuccessType? successType;

/// Create a copy of CampaignState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CampaignSuccessCopyWith<CampaignSuccess> get copyWith => _$CampaignSuccessCopyWithImpl<CampaignSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CampaignSuccess&&const DeepCollectionEquality().equals(other._campaigns, _campaigns)&&(identical(other.successType, successType) || other.successType == successType));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_campaigns),successType);

@override
String toString() {
  return 'CampaignState.success(campaigns: $campaigns, successType: $successType)';
}


}

/// @nodoc
abstract mixin class $CampaignSuccessCopyWith<$Res> implements $CampaignStateCopyWith<$Res> {
  factory $CampaignSuccessCopyWith(CampaignSuccess value, $Res Function(CampaignSuccess) _then) = _$CampaignSuccessCopyWithImpl;
@useResult
$Res call({
 List<CampaignEntity> campaigns, CampaignSuccessType? successType
});




}
/// @nodoc
class _$CampaignSuccessCopyWithImpl<$Res>
    implements $CampaignSuccessCopyWith<$Res> {
  _$CampaignSuccessCopyWithImpl(this._self, this._then);

  final CampaignSuccess _self;
  final $Res Function(CampaignSuccess) _then;

/// Create a copy of CampaignState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? campaigns = null,Object? successType = freezed,}) {
  return _then(CampaignSuccess(
campaigns: null == campaigns ? _self._campaigns : campaigns // ignore: cast_nullable_to_non_nullable
as List<CampaignEntity>,successType: freezed == successType ? _self.successType : successType // ignore: cast_nullable_to_non_nullable
as CampaignSuccessType?,
  ));
}


}

/// @nodoc


class CampaignFailure implements CampaignState {
  const CampaignFailure({required this.error});
  

 final  CampaignError error;

/// Create a copy of CampaignState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CampaignFailureCopyWith<CampaignFailure> get copyWith => _$CampaignFailureCopyWithImpl<CampaignFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CampaignFailure&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'CampaignState.failure(error: $error)';
}


}

/// @nodoc
abstract mixin class $CampaignFailureCopyWith<$Res> implements $CampaignStateCopyWith<$Res> {
  factory $CampaignFailureCopyWith(CampaignFailure value, $Res Function(CampaignFailure) _then) = _$CampaignFailureCopyWithImpl;
@useResult
$Res call({
 CampaignError error
});


$CampaignErrorCopyWith<$Res> get error;

}
/// @nodoc
class _$CampaignFailureCopyWithImpl<$Res>
    implements $CampaignFailureCopyWith<$Res> {
  _$CampaignFailureCopyWithImpl(this._self, this._then);

  final CampaignFailure _self;
  final $Res Function(CampaignFailure) _then;

/// Create a copy of CampaignState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(CampaignFailure(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as CampaignError,
  ));
}

/// Create a copy of CampaignState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CampaignErrorCopyWith<$Res> get error {
  
  return $CampaignErrorCopyWith<$Res>(_self.error, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}

// dart format on
