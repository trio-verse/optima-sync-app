part of 'whatever_bloc.dart';

@freezed
class WhateverState with _$WhateverState {
  const factory WhateverState.initial() = _Initial;
  const factory WhateverState.loading() = _Loading;
  const factory WhateverState.success({required List<int> data}) = _Success;
  const factory WhateverState.failure({required WhateverFailure failure}) =
      _Failure;
}
