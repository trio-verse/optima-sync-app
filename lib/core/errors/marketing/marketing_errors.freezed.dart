// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'marketing_errors.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CampaignError {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CampaignError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CampaignError()';
}


}

/// @nodoc
class $CampaignErrorCopyWith<$Res>  {
$CampaignErrorCopyWith(CampaignError _, $Res Function(CampaignError) __);
}


/// Adds pattern-matching-related methods to [CampaignError].
extension CampaignErrorPatterns on CampaignError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Offline value)?  offline,TResult Function( _SessionExpired value)?  sessionExpired,TResult Function( _NoOrganization value)?  noOrganization,TResult Function( _InvalidData value)?  invalidData,TResult Function( _NotFound value)?  notFound,TResult Function( _ServerError value)?  serverError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Offline() when offline != null:
return offline(_that);case _SessionExpired() when sessionExpired != null:
return sessionExpired(_that);case _NoOrganization() when noOrganization != null:
return noOrganization(_that);case _InvalidData() when invalidData != null:
return invalidData(_that);case _NotFound() when notFound != null:
return notFound(_that);case _ServerError() when serverError != null:
return serverError(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Offline value)  offline,required TResult Function( _SessionExpired value)  sessionExpired,required TResult Function( _NoOrganization value)  noOrganization,required TResult Function( _InvalidData value)  invalidData,required TResult Function( _NotFound value)  notFound,required TResult Function( _ServerError value)  serverError,}){
final _that = this;
switch (_that) {
case _Offline():
return offline(_that);case _SessionExpired():
return sessionExpired(_that);case _NoOrganization():
return noOrganization(_that);case _InvalidData():
return invalidData(_that);case _NotFound():
return notFound(_that);case _ServerError():
return serverError(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Offline value)?  offline,TResult? Function( _SessionExpired value)?  sessionExpired,TResult? Function( _NoOrganization value)?  noOrganization,TResult? Function( _InvalidData value)?  invalidData,TResult? Function( _NotFound value)?  notFound,TResult? Function( _ServerError value)?  serverError,}){
final _that = this;
switch (_that) {
case _Offline() when offline != null:
return offline(_that);case _SessionExpired() when sessionExpired != null:
return sessionExpired(_that);case _NoOrganization() when noOrganization != null:
return noOrganization(_that);case _InvalidData() when invalidData != null:
return invalidData(_that);case _NotFound() when notFound != null:
return notFound(_that);case _ServerError() when serverError != null:
return serverError(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  offline,TResult Function()?  sessionExpired,TResult Function()?  noOrganization,TResult Function()?  invalidData,TResult Function()?  notFound,TResult Function()?  serverError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Offline() when offline != null:
return offline();case _SessionExpired() when sessionExpired != null:
return sessionExpired();case _NoOrganization() when noOrganization != null:
return noOrganization();case _InvalidData() when invalidData != null:
return invalidData();case _NotFound() when notFound != null:
return notFound();case _ServerError() when serverError != null:
return serverError();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  offline,required TResult Function()  sessionExpired,required TResult Function()  noOrganization,required TResult Function()  invalidData,required TResult Function()  notFound,required TResult Function()  serverError,}) {final _that = this;
switch (_that) {
case _Offline():
return offline();case _SessionExpired():
return sessionExpired();case _NoOrganization():
return noOrganization();case _InvalidData():
return invalidData();case _NotFound():
return notFound();case _ServerError():
return serverError();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  offline,TResult? Function()?  sessionExpired,TResult? Function()?  noOrganization,TResult? Function()?  invalidData,TResult? Function()?  notFound,TResult? Function()?  serverError,}) {final _that = this;
switch (_that) {
case _Offline() when offline != null:
return offline();case _SessionExpired() when sessionExpired != null:
return sessionExpired();case _NoOrganization() when noOrganization != null:
return noOrganization();case _InvalidData() when invalidData != null:
return invalidData();case _NotFound() when notFound != null:
return notFound();case _ServerError() when serverError != null:
return serverError();case _:
  return null;

}
}

}

/// @nodoc


class _Offline implements CampaignError {
  const _Offline();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Offline);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CampaignError.offline()';
}


}




/// @nodoc


class _SessionExpired implements CampaignError {
  const _SessionExpired();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionExpired);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CampaignError.sessionExpired()';
}


}




/// @nodoc


class _NoOrganization implements CampaignError {
  const _NoOrganization();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoOrganization);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CampaignError.noOrganization()';
}


}




/// @nodoc


class _InvalidData implements CampaignError {
  const _InvalidData();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvalidData);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CampaignError.invalidData()';
}


}




/// @nodoc


class _NotFound implements CampaignError {
  const _NotFound();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotFound);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CampaignError.notFound()';
}


}




/// @nodoc


class _ServerError implements CampaignError {
  const _ServerError();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CampaignError.serverError()';
}


}




/// @nodoc
mixin _$ContentError {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContentError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ContentError()';
}


}

/// @nodoc
class $ContentErrorCopyWith<$Res>  {
$ContentErrorCopyWith(ContentError _, $Res Function(ContentError) __);
}


/// Adds pattern-matching-related methods to [ContentError].
extension ContentErrorPatterns on ContentError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _ContentOffline value)?  offline,TResult Function( _ContentSessionExpired value)?  sessionExpired,TResult Function( _ContentNoOrganization value)?  noOrganization,TResult Function( _ContentInvalidData value)?  invalidData,TResult Function( _ContentNotFound value)?  notFound,TResult Function( _ContentServerError value)?  serverError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContentOffline() when offline != null:
return offline(_that);case _ContentSessionExpired() when sessionExpired != null:
return sessionExpired(_that);case _ContentNoOrganization() when noOrganization != null:
return noOrganization(_that);case _ContentInvalidData() when invalidData != null:
return invalidData(_that);case _ContentNotFound() when notFound != null:
return notFound(_that);case _ContentServerError() when serverError != null:
return serverError(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _ContentOffline value)  offline,required TResult Function( _ContentSessionExpired value)  sessionExpired,required TResult Function( _ContentNoOrganization value)  noOrganization,required TResult Function( _ContentInvalidData value)  invalidData,required TResult Function( _ContentNotFound value)  notFound,required TResult Function( _ContentServerError value)  serverError,}){
final _that = this;
switch (_that) {
case _ContentOffline():
return offline(_that);case _ContentSessionExpired():
return sessionExpired(_that);case _ContentNoOrganization():
return noOrganization(_that);case _ContentInvalidData():
return invalidData(_that);case _ContentNotFound():
return notFound(_that);case _ContentServerError():
return serverError(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _ContentOffline value)?  offline,TResult? Function( _ContentSessionExpired value)?  sessionExpired,TResult? Function( _ContentNoOrganization value)?  noOrganization,TResult? Function( _ContentInvalidData value)?  invalidData,TResult? Function( _ContentNotFound value)?  notFound,TResult? Function( _ContentServerError value)?  serverError,}){
final _that = this;
switch (_that) {
case _ContentOffline() when offline != null:
return offline(_that);case _ContentSessionExpired() when sessionExpired != null:
return sessionExpired(_that);case _ContentNoOrganization() when noOrganization != null:
return noOrganization(_that);case _ContentInvalidData() when invalidData != null:
return invalidData(_that);case _ContentNotFound() when notFound != null:
return notFound(_that);case _ContentServerError() when serverError != null:
return serverError(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  offline,TResult Function()?  sessionExpired,TResult Function()?  noOrganization,TResult Function()?  invalidData,TResult Function()?  notFound,TResult Function()?  serverError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContentOffline() when offline != null:
return offline();case _ContentSessionExpired() when sessionExpired != null:
return sessionExpired();case _ContentNoOrganization() when noOrganization != null:
return noOrganization();case _ContentInvalidData() when invalidData != null:
return invalidData();case _ContentNotFound() when notFound != null:
return notFound();case _ContentServerError() when serverError != null:
return serverError();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  offline,required TResult Function()  sessionExpired,required TResult Function()  noOrganization,required TResult Function()  invalidData,required TResult Function()  notFound,required TResult Function()  serverError,}) {final _that = this;
switch (_that) {
case _ContentOffline():
return offline();case _ContentSessionExpired():
return sessionExpired();case _ContentNoOrganization():
return noOrganization();case _ContentInvalidData():
return invalidData();case _ContentNotFound():
return notFound();case _ContentServerError():
return serverError();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  offline,TResult? Function()?  sessionExpired,TResult? Function()?  noOrganization,TResult? Function()?  invalidData,TResult? Function()?  notFound,TResult? Function()?  serverError,}) {final _that = this;
switch (_that) {
case _ContentOffline() when offline != null:
return offline();case _ContentSessionExpired() when sessionExpired != null:
return sessionExpired();case _ContentNoOrganization() when noOrganization != null:
return noOrganization();case _ContentInvalidData() when invalidData != null:
return invalidData();case _ContentNotFound() when notFound != null:
return notFound();case _ContentServerError() when serverError != null:
return serverError();case _:
  return null;

}
}

}

/// @nodoc


class _ContentOffline implements ContentError {
  const _ContentOffline();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContentOffline);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ContentError.offline()';
}


}




/// @nodoc


class _ContentSessionExpired implements ContentError {
  const _ContentSessionExpired();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContentSessionExpired);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ContentError.sessionExpired()';
}


}




/// @nodoc


class _ContentNoOrganization implements ContentError {
  const _ContentNoOrganization();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContentNoOrganization);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ContentError.noOrganization()';
}


}




/// @nodoc


class _ContentInvalidData implements ContentError {
  const _ContentInvalidData();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContentInvalidData);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ContentError.invalidData()';
}


}




/// @nodoc


class _ContentNotFound implements ContentError {
  const _ContentNotFound();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContentNotFound);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ContentError.notFound()';
}


}




/// @nodoc


class _ContentServerError implements ContentError {
  const _ContentServerError();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContentServerError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ContentError.serverError()';
}


}




/// @nodoc
mixin _$AnalyticsError {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AnalyticsError()';
}


}

/// @nodoc
class $AnalyticsErrorCopyWith<$Res>  {
$AnalyticsErrorCopyWith(AnalyticsError _, $Res Function(AnalyticsError) __);
}


/// Adds pattern-matching-related methods to [AnalyticsError].
extension AnalyticsErrorPatterns on AnalyticsError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _AnalyticsOffline value)?  offline,TResult Function( _AnalyticsSessionExpired value)?  sessionExpired,TResult Function( _AnalyticsNoOrganization value)?  noOrganization,TResult Function( _AnalyticsInvalidData value)?  invalidData,TResult Function( _AnalyticsNotFound value)?  notFound,TResult Function( _AnalyticsServerError value)?  serverError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsOffline() when offline != null:
return offline(_that);case _AnalyticsSessionExpired() when sessionExpired != null:
return sessionExpired(_that);case _AnalyticsNoOrganization() when noOrganization != null:
return noOrganization(_that);case _AnalyticsInvalidData() when invalidData != null:
return invalidData(_that);case _AnalyticsNotFound() when notFound != null:
return notFound(_that);case _AnalyticsServerError() when serverError != null:
return serverError(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _AnalyticsOffline value)  offline,required TResult Function( _AnalyticsSessionExpired value)  sessionExpired,required TResult Function( _AnalyticsNoOrganization value)  noOrganization,required TResult Function( _AnalyticsInvalidData value)  invalidData,required TResult Function( _AnalyticsNotFound value)  notFound,required TResult Function( _AnalyticsServerError value)  serverError,}){
final _that = this;
switch (_that) {
case _AnalyticsOffline():
return offline(_that);case _AnalyticsSessionExpired():
return sessionExpired(_that);case _AnalyticsNoOrganization():
return noOrganization(_that);case _AnalyticsInvalidData():
return invalidData(_that);case _AnalyticsNotFound():
return notFound(_that);case _AnalyticsServerError():
return serverError(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _AnalyticsOffline value)?  offline,TResult? Function( _AnalyticsSessionExpired value)?  sessionExpired,TResult? Function( _AnalyticsNoOrganization value)?  noOrganization,TResult? Function( _AnalyticsInvalidData value)?  invalidData,TResult? Function( _AnalyticsNotFound value)?  notFound,TResult? Function( _AnalyticsServerError value)?  serverError,}){
final _that = this;
switch (_that) {
case _AnalyticsOffline() when offline != null:
return offline(_that);case _AnalyticsSessionExpired() when sessionExpired != null:
return sessionExpired(_that);case _AnalyticsNoOrganization() when noOrganization != null:
return noOrganization(_that);case _AnalyticsInvalidData() when invalidData != null:
return invalidData(_that);case _AnalyticsNotFound() when notFound != null:
return notFound(_that);case _AnalyticsServerError() when serverError != null:
return serverError(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  offline,TResult Function()?  sessionExpired,TResult Function()?  noOrganization,TResult Function()?  invalidData,TResult Function()?  notFound,TResult Function()?  serverError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsOffline() when offline != null:
return offline();case _AnalyticsSessionExpired() when sessionExpired != null:
return sessionExpired();case _AnalyticsNoOrganization() when noOrganization != null:
return noOrganization();case _AnalyticsInvalidData() when invalidData != null:
return invalidData();case _AnalyticsNotFound() when notFound != null:
return notFound();case _AnalyticsServerError() when serverError != null:
return serverError();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  offline,required TResult Function()  sessionExpired,required TResult Function()  noOrganization,required TResult Function()  invalidData,required TResult Function()  notFound,required TResult Function()  serverError,}) {final _that = this;
switch (_that) {
case _AnalyticsOffline():
return offline();case _AnalyticsSessionExpired():
return sessionExpired();case _AnalyticsNoOrganization():
return noOrganization();case _AnalyticsInvalidData():
return invalidData();case _AnalyticsNotFound():
return notFound();case _AnalyticsServerError():
return serverError();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  offline,TResult? Function()?  sessionExpired,TResult? Function()?  noOrganization,TResult? Function()?  invalidData,TResult? Function()?  notFound,TResult? Function()?  serverError,}) {final _that = this;
switch (_that) {
case _AnalyticsOffline() when offline != null:
return offline();case _AnalyticsSessionExpired() when sessionExpired != null:
return sessionExpired();case _AnalyticsNoOrganization() when noOrganization != null:
return noOrganization();case _AnalyticsInvalidData() when invalidData != null:
return invalidData();case _AnalyticsNotFound() when notFound != null:
return notFound();case _AnalyticsServerError() when serverError != null:
return serverError();case _:
  return null;

}
}

}

/// @nodoc


class _AnalyticsOffline implements AnalyticsError {
  const _AnalyticsOffline();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsOffline);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AnalyticsError.offline()';
}


}




/// @nodoc


class _AnalyticsSessionExpired implements AnalyticsError {
  const _AnalyticsSessionExpired();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsSessionExpired);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AnalyticsError.sessionExpired()';
}


}




/// @nodoc


class _AnalyticsNoOrganization implements AnalyticsError {
  const _AnalyticsNoOrganization();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsNoOrganization);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AnalyticsError.noOrganization()';
}


}




/// @nodoc


class _AnalyticsInvalidData implements AnalyticsError {
  const _AnalyticsInvalidData();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsInvalidData);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AnalyticsError.invalidData()';
}


}




/// @nodoc


class _AnalyticsNotFound implements AnalyticsError {
  const _AnalyticsNotFound();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsNotFound);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AnalyticsError.notFound()';
}


}




/// @nodoc


class _AnalyticsServerError implements AnalyticsError {
  const _AnalyticsServerError();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsServerError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AnalyticsError.serverError()';
}


}




// dart format on
