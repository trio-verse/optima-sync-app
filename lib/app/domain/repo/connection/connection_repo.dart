import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/connection_entity.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

abstract class ConnectionRepository {
  Future<Either<WhateverFailure, List<ConnectionEntity>>> getClientConnections(
    String clientId,
  );

  Future<Either<WhateverFailure, List<ConnectionEntity>>> getAllConnections();

  // Future<Either<WhateverFailure, ConnectionEntity>> getConnection(
  //   String connectionId,
  // );

  Future<Either<WhateverFailure, ConnectionEntity>> createConnection({
    required String clientId,
    required ConnectionEntity connection,
  });

  Future<Either<WhateverFailure, ConnectionEntity>> updateConnection({
    required String id,
    required ConnectionEntity connection,
  });

  Future<Either<WhateverFailure, ConnectionEntity>> updateConnectionStage({
    required String id,
    required String stage,
    required ConnectionEntity current,
  });

  Future<Either<WhateverFailure, void>> deleteConnection(String id);
}
