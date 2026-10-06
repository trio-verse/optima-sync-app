part of 'whatever_bloc.dart';

@freezed
class WhateverEvent with _$WhateverEvent {
  const factory WhateverEvent.started() = _Started;
  const factory WhateverEvent.getAll() = _GetAll;
  const factory WhateverEvent.delete() = _Delete;
}
