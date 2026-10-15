// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connection_errors.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConnectionError {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectionError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ConnectionError()';
}


}

/// @nodoc
class $ConnectionErrorCopyWith<$Res>  {
$ConnectionErrorCopyWith(ConnectionError _, $Res Function(ConnectionError) __);
}


/// Adds pattern-matching-related methods to [ConnectionError].
extension ConnectionErrorPatterns on ConnectionError {
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


class _Offline implements ConnectionError {
  const _Offline();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Offline);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ConnectionError.offline()';
}


}




/// @nodoc


class _SessionExpired implements ConnectionError {
  const _SessionExpired();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionExpired);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ConnectionError.sessionExpired()';
}


}




/// @nodoc


class _NoOrganization implements ConnectionError {
  const _NoOrganization();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoOrganization);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ConnectionError.noOrganization()';
}


}




/// @nodoc


class _InvalidData implements ConnectionError {
  const _InvalidData();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvalidData);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ConnectionError.invalidData()';
}


}




/// @nodoc


class _NotFound implements ConnectionError {
  const _NotFound();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotFound);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ConnectionError.notFound()';
}


}




/// @nodoc


class _ServerError implements ConnectionError {
  const _ServerError();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ConnectionError.serverError()';
}


}




// dart format on
