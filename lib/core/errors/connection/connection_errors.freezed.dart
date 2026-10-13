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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _ServerError value)?  serverError,TResult Function( _ConnectionOffline value)?  connectionOffline,TResult Function( _Database value)?  database,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServerError() when serverError != null:
return serverError(_that);case _ConnectionOffline() when connectionOffline != null:
return connectionOffline(_that);case _Database() when database != null:
return database(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _ServerError value)  serverError,required TResult Function( _ConnectionOffline value)  connectionOffline,required TResult Function( _Database value)  database,}){
final _that = this;
switch (_that) {
case _ServerError():
return serverError(_that);case _ConnectionOffline():
return connectionOffline(_that);case _Database():
return database(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _ServerError value)?  serverError,TResult? Function( _ConnectionOffline value)?  connectionOffline,TResult? Function( _Database value)?  database,}){
final _that = this;
switch (_that) {
case _ServerError() when serverError != null:
return serverError(_that);case _ConnectionOffline() when connectionOffline != null:
return connectionOffline(_that);case _Database() when database != null:
return database(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  serverError,TResult Function()?  connectionOffline,TResult Function()?  database,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServerError() when serverError != null:
return serverError();case _ConnectionOffline() when connectionOffline != null:
return connectionOffline();case _Database() when database != null:
return database();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  serverError,required TResult Function()  connectionOffline,required TResult Function()  database,}) {final _that = this;
switch (_that) {
case _ServerError():
return serverError();case _ConnectionOffline():
return connectionOffline();case _Database():
return database();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  serverError,TResult? Function()?  connectionOffline,TResult? Function()?  database,}) {final _that = this;
switch (_that) {
case _ServerError() when serverError != null:
return serverError();case _ConnectionOffline() when connectionOffline != null:
return connectionOffline();case _Database() when database != null:
return database();case _:
  return null;

}
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




/// @nodoc


class _ConnectionOffline implements ConnectionError {
  const _ConnectionOffline();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConnectionOffline);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ConnectionError.connectionOffline()';
}


}




/// @nodoc


class _Database implements ConnectionError {
  const _Database();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Database);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ConnectionError.database()';
}


}




// dart format on
