// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ContentEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContentEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ContentEvent()';
}


}

/// @nodoc
class $ContentEventCopyWith<$Res>  {
$ContentEventCopyWith(ContentEvent _, $Res Function(ContentEvent) __);
}


/// Adds pattern-matching-related methods to [ContentEvent].
extension ContentEventPatterns on ContentEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _GetAllCampaignContents value)?  getAllCampaignContents,TResult Function( _AddCampaignContent value)?  addCampaignContent,TResult Function( _UpdateCampaignContent value)?  updateCampaignContent,TResult Function( _DeleteCampaignContent value)?  deleteCampaignContent,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetAllCampaignContents() when getAllCampaignContents != null:
return getAllCampaignContents(_that);case _AddCampaignContent() when addCampaignContent != null:
return addCampaignContent(_that);case _UpdateCampaignContent() when updateCampaignContent != null:
return updateCampaignContent(_that);case _DeleteCampaignContent() when deleteCampaignContent != null:
return deleteCampaignContent(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _GetAllCampaignContents value)  getAllCampaignContents,required TResult Function( _AddCampaignContent value)  addCampaignContent,required TResult Function( _UpdateCampaignContent value)  updateCampaignContent,required TResult Function( _DeleteCampaignContent value)  deleteCampaignContent,}){
final _that = this;
switch (_that) {
case _GetAllCampaignContents():
return getAllCampaignContents(_that);case _AddCampaignContent():
return addCampaignContent(_that);case _UpdateCampaignContent():
return updateCampaignContent(_that);case _DeleteCampaignContent():
return deleteCampaignContent(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _GetAllCampaignContents value)?  getAllCampaignContents,TResult? Function( _AddCampaignContent value)?  addCampaignContent,TResult? Function( _UpdateCampaignContent value)?  updateCampaignContent,TResult? Function( _DeleteCampaignContent value)?  deleteCampaignContent,}){
final _that = this;
switch (_that) {
case _GetAllCampaignContents() when getAllCampaignContents != null:
return getAllCampaignContents(_that);case _AddCampaignContent() when addCampaignContent != null:
return addCampaignContent(_that);case _UpdateCampaignContent() when updateCampaignContent != null:
return updateCampaignContent(_that);case _DeleteCampaignContent() when deleteCampaignContent != null:
return deleteCampaignContent(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String campaignId)?  getAllCampaignContents,TResult Function( ContentEntity content)?  addCampaignContent,TResult Function( ContentEntity content)?  updateCampaignContent,TResult Function( ContentEntity content)?  deleteCampaignContent,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetAllCampaignContents() when getAllCampaignContents != null:
return getAllCampaignContents(_that.campaignId);case _AddCampaignContent() when addCampaignContent != null:
return addCampaignContent(_that.content);case _UpdateCampaignContent() when updateCampaignContent != null:
return updateCampaignContent(_that.content);case _DeleteCampaignContent() when deleteCampaignContent != null:
return deleteCampaignContent(_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String campaignId)  getAllCampaignContents,required TResult Function( ContentEntity content)  addCampaignContent,required TResult Function( ContentEntity content)  updateCampaignContent,required TResult Function( ContentEntity content)  deleteCampaignContent,}) {final _that = this;
switch (_that) {
case _GetAllCampaignContents():
return getAllCampaignContents(_that.campaignId);case _AddCampaignContent():
return addCampaignContent(_that.content);case _UpdateCampaignContent():
return updateCampaignContent(_that.content);case _DeleteCampaignContent():
return deleteCampaignContent(_that.content);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String campaignId)?  getAllCampaignContents,TResult? Function( ContentEntity content)?  addCampaignContent,TResult? Function( ContentEntity content)?  updateCampaignContent,TResult? Function( ContentEntity content)?  deleteCampaignContent,}) {final _that = this;
switch (_that) {
case _GetAllCampaignContents() when getAllCampaignContents != null:
return getAllCampaignContents(_that.campaignId);case _AddCampaignContent() when addCampaignContent != null:
return addCampaignContent(_that.content);case _UpdateCampaignContent() when updateCampaignContent != null:
return updateCampaignContent(_that.content);case _DeleteCampaignContent() when deleteCampaignContent != null:
return deleteCampaignContent(_that.content);case _:
  return null;

}
}

}

/// @nodoc


class _GetAllCampaignContents implements ContentEvent {
  const _GetAllCampaignContents({required this.campaignId});
  

 final  String campaignId;

/// Create a copy of ContentEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetAllCampaignContentsCopyWith<_GetAllCampaignContents> get copyWith => __$GetAllCampaignContentsCopyWithImpl<_GetAllCampaignContents>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetAllCampaignContents&&(identical(other.campaignId, campaignId) || other.campaignId == campaignId));
}


@override
int get hashCode => Object.hash(runtimeType,campaignId);

@override
String toString() {
  return 'ContentEvent.getAllCampaignContents(campaignId: $campaignId)';
}


}

/// @nodoc
abstract mixin class _$GetAllCampaignContentsCopyWith<$Res> implements $ContentEventCopyWith<$Res> {
  factory _$GetAllCampaignContentsCopyWith(_GetAllCampaignContents value, $Res Function(_GetAllCampaignContents) _then) = __$GetAllCampaignContentsCopyWithImpl;
@useResult
$Res call({
 String campaignId
});




}
/// @nodoc
class __$GetAllCampaignContentsCopyWithImpl<$Res>
    implements _$GetAllCampaignContentsCopyWith<$Res> {
  __$GetAllCampaignContentsCopyWithImpl(this._self, this._then);

  final _GetAllCampaignContents _self;
  final $Res Function(_GetAllCampaignContents) _then;

/// Create a copy of ContentEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? campaignId = null,}) {
  return _then(_GetAllCampaignContents(
campaignId: null == campaignId ? _self.campaignId : campaignId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _AddCampaignContent implements ContentEvent {
  const _AddCampaignContent({required this.content});
  

 final  ContentEntity content;

/// Create a copy of ContentEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddCampaignContentCopyWith<_AddCampaignContent> get copyWith => __$AddCampaignContentCopyWithImpl<_AddCampaignContent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddCampaignContent&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,content);

@override
String toString() {
  return 'ContentEvent.addCampaignContent(content: $content)';
}


}

/// @nodoc
abstract mixin class _$AddCampaignContentCopyWith<$Res> implements $ContentEventCopyWith<$Res> {
  factory _$AddCampaignContentCopyWith(_AddCampaignContent value, $Res Function(_AddCampaignContent) _then) = __$AddCampaignContentCopyWithImpl;
@useResult
$Res call({
 ContentEntity content
});




}
/// @nodoc
class __$AddCampaignContentCopyWithImpl<$Res>
    implements _$AddCampaignContentCopyWith<$Res> {
  __$AddCampaignContentCopyWithImpl(this._self, this._then);

  final _AddCampaignContent _self;
  final $Res Function(_AddCampaignContent) _then;

/// Create a copy of ContentEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? content = null,}) {
  return _then(_AddCampaignContent(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as ContentEntity,
  ));
}


}

/// @nodoc


class _UpdateCampaignContent implements ContentEvent {
  const _UpdateCampaignContent({required this.content});
  

 final  ContentEntity content;

/// Create a copy of ContentEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateCampaignContentCopyWith<_UpdateCampaignContent> get copyWith => __$UpdateCampaignContentCopyWithImpl<_UpdateCampaignContent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateCampaignContent&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,content);

@override
String toString() {
  return 'ContentEvent.updateCampaignContent(content: $content)';
}


}

/// @nodoc
abstract mixin class _$UpdateCampaignContentCopyWith<$Res> implements $ContentEventCopyWith<$Res> {
  factory _$UpdateCampaignContentCopyWith(_UpdateCampaignContent value, $Res Function(_UpdateCampaignContent) _then) = __$UpdateCampaignContentCopyWithImpl;
@useResult
$Res call({
 ContentEntity content
});




}
/// @nodoc
class __$UpdateCampaignContentCopyWithImpl<$Res>
    implements _$UpdateCampaignContentCopyWith<$Res> {
  __$UpdateCampaignContentCopyWithImpl(this._self, this._then);

  final _UpdateCampaignContent _self;
  final $Res Function(_UpdateCampaignContent) _then;

/// Create a copy of ContentEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? content = null,}) {
  return _then(_UpdateCampaignContent(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as ContentEntity,
  ));
}


}

/// @nodoc


class _DeleteCampaignContent implements ContentEvent {
  const _DeleteCampaignContent({required this.content});
  

 final  ContentEntity content;

/// Create a copy of ContentEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeleteCampaignContentCopyWith<_DeleteCampaignContent> get copyWith => __$DeleteCampaignContentCopyWithImpl<_DeleteCampaignContent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteCampaignContent&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,content);

@override
String toString() {
  return 'ContentEvent.deleteCampaignContent(content: $content)';
}


}

/// @nodoc
abstract mixin class _$DeleteCampaignContentCopyWith<$Res> implements $ContentEventCopyWith<$Res> {
  factory _$DeleteCampaignContentCopyWith(_DeleteCampaignContent value, $Res Function(_DeleteCampaignContent) _then) = __$DeleteCampaignContentCopyWithImpl;
@useResult
$Res call({
 ContentEntity content
});




}
/// @nodoc
class __$DeleteCampaignContentCopyWithImpl<$Res>
    implements _$DeleteCampaignContentCopyWith<$Res> {
  __$DeleteCampaignContentCopyWithImpl(this._self, this._then);

  final _DeleteCampaignContent _self;
  final $Res Function(_DeleteCampaignContent) _then;

/// Create a copy of ContentEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? content = null,}) {
  return _then(_DeleteCampaignContent(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as ContentEntity,
  ));
}


}

/// @nodoc
mixin _$ContentState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContentState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ContentState()';
}


}

/// @nodoc
class $ContentStateCopyWith<$Res>  {
$ContentStateCopyWith(ContentState _, $Res Function(ContentState) __);
}


/// Adds pattern-matching-related methods to [ContentState].
extension ContentStatePatterns on ContentState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Success value)?  success,TResult Function( _Failure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Success() when success != null:
return success(_that);case _Failure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Success value)  success,required TResult Function( _Failure value)  failure,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Success():
return success(_that);case _Failure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Success value)?  success,TResult? Function( _Failure value)?  failure,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Success() when success != null:
return success(_that);case _Failure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<ContentEntity> contents,  String? message)?  success,TResult Function( MarketingError failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Success() when success != null:
return success(_that.contents,_that.message);case _Failure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<ContentEntity> contents,  String? message)  success,required TResult Function( MarketingError failure)  failure,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Success():
return success(_that.contents,_that.message);case _Failure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<ContentEntity> contents,  String? message)?  success,TResult? Function( MarketingError failure)?  failure,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Success() when success != null:
return success(_that.contents,_that.message);case _Failure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements ContentState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ContentState.initial()';
}


}




/// @nodoc


class _Loading implements ContentState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ContentState.loading()';
}


}




/// @nodoc


class _Success implements ContentState {
  const _Success({required final  List<ContentEntity> contents, this.message}): _contents = contents;
  

 final  List<ContentEntity> _contents;
 List<ContentEntity> get contents {
  if (_contents is EqualUnmodifiableListView) return _contents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_contents);
}

 final  String? message;

/// Create a copy of ContentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuccessCopyWith<_Success> get copyWith => __$SuccessCopyWithImpl<_Success>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Success&&const DeepCollectionEquality().equals(other._contents, _contents)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_contents),message);

@override
String toString() {
  return 'ContentState.success(contents: $contents, message: $message)';
}


}

/// @nodoc
abstract mixin class _$SuccessCopyWith<$Res> implements $ContentStateCopyWith<$Res> {
  factory _$SuccessCopyWith(_Success value, $Res Function(_Success) _then) = __$SuccessCopyWithImpl;
@useResult
$Res call({
 List<ContentEntity> contents, String? message
});




}
/// @nodoc
class __$SuccessCopyWithImpl<$Res>
    implements _$SuccessCopyWith<$Res> {
  __$SuccessCopyWithImpl(this._self, this._then);

  final _Success _self;
  final $Res Function(_Success) _then;

/// Create a copy of ContentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? contents = null,Object? message = freezed,}) {
  return _then(_Success(
contents: null == contents ? _self._contents : contents // ignore: cast_nullable_to_non_nullable
as List<ContentEntity>,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _Failure implements ContentState {
  const _Failure({required this.failure});
  

 final  MarketingError failure;

/// Create a copy of ContentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FailureCopyWith<_Failure> get copyWith => __$FailureCopyWithImpl<_Failure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Failure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'ContentState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$FailureCopyWith<$Res> implements $ContentStateCopyWith<$Res> {
  factory _$FailureCopyWith(_Failure value, $Res Function(_Failure) _then) = __$FailureCopyWithImpl;
@useResult
$Res call({
 MarketingError failure
});


$MarketingErrorCopyWith<$Res> get failure;

}
/// @nodoc
class __$FailureCopyWithImpl<$Res>
    implements _$FailureCopyWith<$Res> {
  __$FailureCopyWithImpl(this._self, this._then);

  final _Failure _self;
  final $Res Function(_Failure) _then;

/// Create a copy of ContentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(_Failure(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as MarketingError,
  ));
}

/// Create a copy of ContentState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MarketingErrorCopyWith<$Res> get failure {
  
  return $MarketingErrorCopyWith<$Res>(_self.failure, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on
