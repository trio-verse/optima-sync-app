import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'connection_manager_event.dart';
part 'connection_manager_state.dart';
part 'connection_manager_bloc.freezed.dart';

class ConnectionManagerBloc extends Bloc<ConnectionManagerEvent, ConnectionManagerState> {
  ConnectionManagerBloc() : super(_Initial()) {
    on<ConnectionManagerEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
