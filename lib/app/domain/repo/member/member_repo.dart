import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/member_entity.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

abstract class MemberRepository {
  Future<Either<WhateverFailure, List<MemberEntity>>> getMembers();

  Future<Either<WhateverFailure, MemberEntity>> addMember({
    required String email,
    required String role,
  });

  Future<Either<WhateverFailure, void>> updateMemberRole({
    required String memberId,
    required String role,
  });
}
