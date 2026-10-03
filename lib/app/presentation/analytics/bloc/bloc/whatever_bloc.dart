import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

part 'whatever_bloc.freezed.dart';
part 'whatever_event.dart';
part 'whatever_state.dart';

class WhateverBloc extends Bloc<WhateverEvent, WhateverState> {
  WhateverBloc() : super(.initial()) {
    on<WhateverEvent>((event, emit) {
      WhateverFailure f = .database();
      // TODO: implement event handler

      f.when(
        serverError: () => 'serverError',
        whatoffline: () => 'whatoffline',
        database: () => 'database',
      );
      emit(.success(data: []));
    });
  }
}
