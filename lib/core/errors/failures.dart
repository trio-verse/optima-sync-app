import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
abstract class WhateverFailure with _$WhateverFailure {
  const factory WhateverFailure.serverError() = _ServerError;
  const factory WhateverFailure.whatoffline() = _WhatOffline;
  const factory WhateverFailure.database() = _Database;
}
