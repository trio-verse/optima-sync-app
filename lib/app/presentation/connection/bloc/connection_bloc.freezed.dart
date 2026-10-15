// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connection_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConnectionEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectionEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ConnectionEvent()';
}


}

/// @nodoc
class $ConnectionEventCopyWith<$Res>  {
$ConnectionEventCopyWith(ConnectionEvent _, $Res Function(ConnectionEvent) __);
}


/// Adds pattern-matching-related methods to [ConnectionEvent].
extension ConnectionEventPatterns on ConnectionEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadConnections value)?  loadConnections,TResult Function( LoadAllConnections value)?  loadAllConnections,TResult Function( AddConnectionSubmitted value)?  addSubmitted,TResult Function( UpdateConnectionSubmitted value)?  updateSubmitted,TResult Function( DeleteConnectionSubmitted value)?  deleteSubmitted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadConnections() when loadConnections != null:
return loadConnections(_that);case LoadAllConnections() when loadAllConnections != null:
return loadAllConnections(_that);case AddConnectionSubmitted() when addSubmitted != null:
return addSubmitted(_that);case UpdateConnectionSubmitted() when updateSubmitted != null:
return updateSubmitted(_that);case DeleteConnectionSubmitted() when deleteSubmitted != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadConnections value)  loadConnections,required TResult Function( LoadAllConnections value)  loadAllConnections,required TResult Function( AddConnectionSubmitted value)  addSubmitted,required TResult Function( UpdateConnectionSubmitted value)  updateSubmitted,required TResult Function( DeleteConnectionSubmitted value)  deleteSubmitted,}){
final _that = this;
switch (_that) {
case LoadConnections():
return loadConnections(_that);case LoadAllConnections():
return loadAllConnections(_that);case AddConnectionSubmitted():
return addSubmitted(_that);case UpdateConnectionSubmitted():
return updateSubmitted(_that);case DeleteConnectionSubmitted():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadConnections value)?  loadConnections,TResult? Function( LoadAllConnections value)?  loadAllConnections,TResult? Function( AddConnectionSubmitted value)?  addSubmitted,TResult? Function( UpdateConnectionSubmitted value)?  updateSubmitted,TResult? Function( DeleteConnectionSubmitted value)?  deleteSubmitted,}){
final _that = this;
switch (_that) {
case LoadConnections() when loadConnections != null:
return loadConnections(_that);case LoadAllConnections() when loadAllConnections != null:
return loadAllConnections(_that);case AddConnectionSubmitted() when addSubmitted != null:
return addSubmitted(_that);case UpdateConnectionSubmitted() when updateSubmitted != null:
return updateSubmitted(_that);case DeleteConnectionSubmitted() when deleteSubmitted != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String clientId)?  loadConnections,TResult Function()?  loadAllConnections,TResult Function( ConnectionEntity connection)?  addSubmitted,TResult Function( ConnectionEntity connection)?  updateSubmitted,TResult Function( String id)?  deleteSubmitted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadConnections() when loadConnections != null:
return loadConnections(_that.clientId);case LoadAllConnections() when loadAllConnections != null:
return loadAllConnections();case AddConnectionSubmitted() when addSubmitted != null:
return addSubmitted(_that.connection);case UpdateConnectionSubmitted() when updateSubmitted != null:
return updateSubmitted(_that.connection);case DeleteConnectionSubmitted() when deleteSubmitted != null:
return deleteSubmitted(_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String clientId)  loadConnections,required TResult Function()  loadAllConnections,required TResult Function( ConnectionEntity connection)  addSubmitted,required TResult Function( ConnectionEntity connection)  updateSubmitted,required TResult Function( String id)  deleteSubmitted,}) {final _that = this;
switch (_that) {
case LoadConnections():
return loadConnections(_that.clientId);case LoadAllConnections():
return loadAllConnections();case AddConnectionSubmitted():
return addSubmitted(_that.connection);case UpdateConnectionSubmitted():
return updateSubmitted(_that.connection);case DeleteConnectionSubmitted():
return deleteSubmitted(_that.id);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String clientId)?  loadConnections,TResult? Function()?  loadAllConnections,TResult? Function( ConnectionEntity connection)?  addSubmitted,TResult? Function( ConnectionEntity connection)?  updateSubmitted,TResult? Function( String id)?  deleteSubmitted,}) {final _that = this;
switch (_that) {
case LoadConnections() when loadConnections != null:
return loadConnections(_that.clientId);case LoadAllConnections() when loadAllConnections != null:
return loadAllConnections();case AddConnectionSubmitted() when addSubmitted != null:
return addSubmitted(_that.connection);case UpdateConnectionSubmitted() when updateSubmitted != null:
return updateSubmitted(_that.connection);case DeleteConnectionSubmitted() when deleteSubmitted != null:
return deleteSubmitted(_that.id);case _:
  return null;

}
}

}

/// @nodoc


class LoadConnections implements ConnectionEvent {
  const LoadConnections({required this.clientId});
  

 final  String clientId;

/// Create a copy of ConnectionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadConnectionsCopyWith<LoadConnections> get copyWith => _$LoadConnectionsCopyWithImpl<LoadConnections>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadConnections&&(identical(other.clientId, clientId) || other.clientId == clientId));
}


@override
int get hashCode => Object.hash(runtimeType,clientId);

@override
String toString() {
  return 'ConnectionEvent.loadConnections(clientId: $clientId)';
}


}

/// @nodoc
abstract mixin class $LoadConnectionsCopyWith<$Res> implements $ConnectionEventCopyWith<$Res> {
  factory $LoadConnectionsCopyWith(LoadConnections value, $Res Function(LoadConnections) _then) = _$LoadConnectionsCopyWithImpl;
@useResult
$Res call({
 String clientId
});




}
/// @nodoc
class _$LoadConnectionsCopyWithImpl<$Res>
    implements $LoadConnectionsCopyWith<$Res> {
  _$LoadConnectionsCopyWithImpl(this._self, this._then);

  final LoadConnections _self;
  final $Res Function(LoadConnections) _then;

/// Create a copy of ConnectionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? clientId = null,}) {
  return _then(LoadConnections(
clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class LoadAllConnections implements ConnectionEvent {
  const LoadAllConnections();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadAllConnections);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ConnectionEvent.loadAllConnections()';
}


}




/// @nodoc


class AddConnectionSubmitted implements ConnectionEvent {
  const AddConnectionSubmitted({required this.connection});
  

 final  ConnectionEntity connection;

/// Create a copy of ConnectionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddConnectionSubmittedCopyWith<AddConnectionSubmitted> get copyWith => _$AddConnectionSubmittedCopyWithImpl<AddConnectionSubmitted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddConnectionSubmitted&&(identical(other.connection, connection) || other.connection == connection));
}


@override
int get hashCode => Object.hash(runtimeType,connection);

@override
String toString() {
  return 'ConnectionEvent.addSubmitted(connection: $connection)';
}


}

/// @nodoc
abstract mixin class $AddConnectionSubmittedCopyWith<$Res> implements $ConnectionEventCopyWith<$Res> {
  factory $AddConnectionSubmittedCopyWith(AddConnectionSubmitted value, $Res Function(AddConnectionSubmitted) _then) = _$AddConnectionSubmittedCopyWithImpl;
@useResult
$Res call({
 ConnectionEntity connection
});




}
/// @nodoc
class _$AddConnectionSubmittedCopyWithImpl<$Res>
    implements $AddConnectionSubmittedCopyWith<$Res> {
  _$AddConnectionSubmittedCopyWithImpl(this._self, this._then);

  final AddConnectionSubmitted _self;
  final $Res Function(AddConnectionSubmitted) _then;

/// Create a copy of ConnectionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? connection = null,}) {
  return _then(AddConnectionSubmitted(
connection: null == connection ? _self.connection : connection // ignore: cast_nullable_to_non_nullable
as ConnectionEntity,
  ));
}


}

/// @nodoc


class UpdateConnectionSubmitted implements ConnectionEvent {
  const UpdateConnectionSubmitted({required this.connection});
  

 final  ConnectionEntity connection;

/// Create a copy of ConnectionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateConnectionSubmittedCopyWith<UpdateConnectionSubmitted> get copyWith => _$UpdateConnectionSubmittedCopyWithImpl<UpdateConnectionSubmitted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateConnectionSubmitted&&(identical(other.connection, connection) || other.connection == connection));
}


@override
int get hashCode => Object.hash(runtimeType,connection);

@override
String toString() {
  return 'ConnectionEvent.updateSubmitted(connection: $connection)';
}


}

/// @nodoc
abstract mixin class $UpdateConnectionSubmittedCopyWith<$Res> implements $ConnectionEventCopyWith<$Res> {
  factory $UpdateConnectionSubmittedCopyWith(UpdateConnectionSubmitted value, $Res Function(UpdateConnectionSubmitted) _then) = _$UpdateConnectionSubmittedCopyWithImpl;
@useResult
$Res call({
 ConnectionEntity connection
});




}
/// @nodoc
class _$UpdateConnectionSubmittedCopyWithImpl<$Res>
    implements $UpdateConnectionSubmittedCopyWith<$Res> {
  _$UpdateConnectionSubmittedCopyWithImpl(this._self, this._then);

  final UpdateConnectionSubmitted _self;
  final $Res Function(UpdateConnectionSubmitted) _then;

/// Create a copy of ConnectionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? connection = null,}) {
  return _then(UpdateConnectionSubmitted(
connection: null == connection ? _self.connection : connection // ignore: cast_nullable_to_non_nullable
as ConnectionEntity,
  ));
}


}

/// @nodoc


class DeleteConnectionSubmitted implements ConnectionEvent {
  const DeleteConnectionSubmitted({required this.id});
  

 final  String id;

/// Create a copy of ConnectionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeleteConnectionSubmittedCopyWith<DeleteConnectionSubmitted> get copyWith => _$DeleteConnectionSubmittedCopyWithImpl<DeleteConnectionSubmitted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteConnectionSubmitted&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'ConnectionEvent.deleteSubmitted(id: $id)';
}


}

/// @nodoc
abstract mixin class $DeleteConnectionSubmittedCopyWith<$Res> implements $ConnectionEventCopyWith<$Res> {
  factory $DeleteConnectionSubmittedCopyWith(DeleteConnectionSubmitted value, $Res Function(DeleteConnectionSubmitted) _then) = _$DeleteConnectionSubmittedCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$DeleteConnectionSubmittedCopyWithImpl<$Res>
    implements $DeleteConnectionSubmittedCopyWith<$Res> {
  _$DeleteConnectionSubmittedCopyWithImpl(this._self, this._then);

  final DeleteConnectionSubmitted _self;
  final $Res Function(DeleteConnectionSubmitted) _then;

/// Create a copy of ConnectionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(DeleteConnectionSubmitted(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ConnectionState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectionState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ConnectionState()';
}


}

/// @nodoc
class $ConnectionStateCopyWith<$Res>  {
$ConnectionStateCopyWith(ConnectionState _, $Res Function(ConnectionState) __);
}


/// Adds pattern-matching-related methods to [ConnectionState].
extension ConnectionStatePatterns on ConnectionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ConnectionInitial value)?  initial,TResult Function( ConnectionLoading value)?  loading,TResult Function( ConnectionSubmitting value)?  submitting,TResult Function( ConnectionSuccess value)?  success,TResult Function( ConnectionFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ConnectionInitial() when initial != null:
return initial(_that);case ConnectionLoading() when loading != null:
return loading(_that);case ConnectionSubmitting() when submitting != null:
return submitting(_that);case ConnectionSuccess() when success != null:
return success(_that);case ConnectionFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ConnectionInitial value)  initial,required TResult Function( ConnectionLoading value)  loading,required TResult Function( ConnectionSubmitting value)  submitting,required TResult Function( ConnectionSuccess value)  success,required TResult Function( ConnectionFailure value)  failure,}){
final _that = this;
switch (_that) {
case ConnectionInitial():
return initial(_that);case ConnectionLoading():
return loading(_that);case ConnectionSubmitting():
return submitting(_that);case ConnectionSuccess():
return success(_that);case ConnectionFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ConnectionInitial value)?  initial,TResult? Function( ConnectionLoading value)?  loading,TResult? Function( ConnectionSubmitting value)?  submitting,TResult? Function( ConnectionSuccess value)?  success,TResult? Function( ConnectionFailure value)?  failure,}){
final _that = this;
switch (_that) {
case ConnectionInitial() when initial != null:
return initial(_that);case ConnectionLoading() when loading != null:
return loading(_that);case ConnectionSubmitting() when submitting != null:
return submitting(_that);case ConnectionSuccess() when success != null:
return success(_that);case ConnectionFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<ConnectionEntity> connections)?  submitting,TResult Function( List<ConnectionEntity> connections,  String? message)?  success,TResult Function( String message,  List<ConnectionEntity>? connections)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ConnectionInitial() when initial != null:
return initial();case ConnectionLoading() when loading != null:
return loading();case ConnectionSubmitting() when submitting != null:
return submitting(_that.connections);case ConnectionSuccess() when success != null:
return success(_that.connections,_that.message);case ConnectionFailure() when failure != null:
return failure(_that.message,_that.connections);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<ConnectionEntity> connections)  submitting,required TResult Function( List<ConnectionEntity> connections,  String? message)  success,required TResult Function( String message,  List<ConnectionEntity>? connections)  failure,}) {final _that = this;
switch (_that) {
case ConnectionInitial():
return initial();case ConnectionLoading():
return loading();case ConnectionSubmitting():
return submitting(_that.connections);case ConnectionSuccess():
return success(_that.connections,_that.message);case ConnectionFailure():
return failure(_that.message,_that.connections);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<ConnectionEntity> connections)?  submitting,TResult? Function( List<ConnectionEntity> connections,  String? message)?  success,TResult? Function( String message,  List<ConnectionEntity>? connections)?  failure,}) {final _that = this;
switch (_that) {
case ConnectionInitial() when initial != null:
return initial();case ConnectionLoading() when loading != null:
return loading();case ConnectionSubmitting() when submitting != null:
return submitting(_that.connections);case ConnectionSuccess() when success != null:
return success(_that.connections,_that.message);case ConnectionFailure() when failure != null:
return failure(_that.message,_that.connections);case _:
  return null;

}
}

}

/// @nodoc


class ConnectionInitial implements ConnectionState {
  const ConnectionInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectionInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ConnectionState.initial()';
}


}




/// @nodoc


class ConnectionLoading implements ConnectionState {
  const ConnectionLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectionLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ConnectionState.loading()';
}


}




/// @nodoc


class ConnectionSubmitting implements ConnectionState {
  const ConnectionSubmitting({required final  List<ConnectionEntity> connections}): _connections = connections;
  

 final  List<ConnectionEntity> _connections;
 List<ConnectionEntity> get connections {
  if (_connections is EqualUnmodifiableListView) return _connections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_connections);
}


/// Create a copy of ConnectionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConnectionSubmittingCopyWith<ConnectionSubmitting> get copyWith => _$ConnectionSubmittingCopyWithImpl<ConnectionSubmitting>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectionSubmitting&&const DeepCollectionEquality().equals(other._connections, _connections));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_connections));

@override
String toString() {
  return 'ConnectionState.submitting(connections: $connections)';
}


}

/// @nodoc
abstract mixin class $ConnectionSubmittingCopyWith<$Res> implements $ConnectionStateCopyWith<$Res> {
  factory $ConnectionSubmittingCopyWith(ConnectionSubmitting value, $Res Function(ConnectionSubmitting) _then) = _$ConnectionSubmittingCopyWithImpl;
@useResult
$Res call({
 List<ConnectionEntity> connections
});




}
/// @nodoc
class _$ConnectionSubmittingCopyWithImpl<$Res>
    implements $ConnectionSubmittingCopyWith<$Res> {
  _$ConnectionSubmittingCopyWithImpl(this._self, this._then);

  final ConnectionSubmitting _self;
  final $Res Function(ConnectionSubmitting) _then;

/// Create a copy of ConnectionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? connections = null,}) {
  return _then(ConnectionSubmitting(
connections: null == connections ? _self._connections : connections // ignore: cast_nullable_to_non_nullable
as List<ConnectionEntity>,
  ));
}


}

/// @nodoc


class ConnectionSuccess implements ConnectionState {
  const ConnectionSuccess({required final  List<ConnectionEntity> connections, this.message}): _connections = connections;
  

 final  List<ConnectionEntity> _connections;
 List<ConnectionEntity> get connections {
  if (_connections is EqualUnmodifiableListView) return _connections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_connections);
}

 final  String? message;

/// Create a copy of ConnectionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConnectionSuccessCopyWith<ConnectionSuccess> get copyWith => _$ConnectionSuccessCopyWithImpl<ConnectionSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectionSuccess&&const DeepCollectionEquality().equals(other._connections, _connections)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_connections),message);

@override
String toString() {
  return 'ConnectionState.success(connections: $connections, message: $message)';
}


}

/// @nodoc
abstract mixin class $ConnectionSuccessCopyWith<$Res> implements $ConnectionStateCopyWith<$Res> {
  factory $ConnectionSuccessCopyWith(ConnectionSuccess value, $Res Function(ConnectionSuccess) _then) = _$ConnectionSuccessCopyWithImpl;
@useResult
$Res call({
 List<ConnectionEntity> connections, String? message
});




}
/// @nodoc
class _$ConnectionSuccessCopyWithImpl<$Res>
    implements $ConnectionSuccessCopyWith<$Res> {
  _$ConnectionSuccessCopyWithImpl(this._self, this._then);

  final ConnectionSuccess _self;
  final $Res Function(ConnectionSuccess) _then;

/// Create a copy of ConnectionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? connections = null,Object? message = freezed,}) {
  return _then(ConnectionSuccess(
connections: null == connections ? _self._connections : connections // ignore: cast_nullable_to_non_nullable
as List<ConnectionEntity>,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ConnectionFailure implements ConnectionState {
  const ConnectionFailure({required this.message, final  List<ConnectionEntity>? connections}): _connections = connections;
  

 final  String message;
 final  List<ConnectionEntity>? _connections;
 List<ConnectionEntity>? get connections {
  final value = _connections;
  if (value == null) return null;
  if (_connections is EqualUnmodifiableListView) return _connections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ConnectionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConnectionFailureCopyWith<ConnectionFailure> get copyWith => _$ConnectionFailureCopyWithImpl<ConnectionFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectionFailure&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._connections, _connections));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(_connections));

@override
String toString() {
  return 'ConnectionState.failure(message: $message, connections: $connections)';
}


}

/// @nodoc
abstract mixin class $ConnectionFailureCopyWith<$Res> implements $ConnectionStateCopyWith<$Res> {
  factory $ConnectionFailureCopyWith(ConnectionFailure value, $Res Function(ConnectionFailure) _then) = _$ConnectionFailureCopyWithImpl;
@useResult
$Res call({
 String message, List<ConnectionEntity>? connections
});




}
/// @nodoc
class _$ConnectionFailureCopyWithImpl<$Res>
    implements $ConnectionFailureCopyWith<$Res> {
  _$ConnectionFailureCopyWithImpl(this._self, this._then);

  final ConnectionFailure _self;
  final $Res Function(ConnectionFailure) _then;

/// Create a copy of ConnectionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? connections = freezed,}) {
  return _then(ConnectionFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,connections: freezed == connections ? _self._connections : connections // ignore: cast_nullable_to_non_nullable
as List<ConnectionEntity>?,
  ));
}


}

// dart format on
