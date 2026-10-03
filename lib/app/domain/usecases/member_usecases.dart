import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/member_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/member/member_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class MemberUsecases {
  final MemberRepository repo;

  MemberUsecases({required this.repo});

  Future<Either<WhateverFailure, List<MemberEntity>>> getMembers() {
    return repo.getMembers();
  }

  Future<Either<WhateverFailure, MemberEntity>> addMember({
    required String email,
    required String role,
  }) {
    return repo.addMember(email: email, role: role);
  }

  Future<Either<WhateverFailure, void>> updateMemberRole({
    required String memberId,
    required String role,
  }) {
    return repo.updateMemberRole(memberId: memberId, role: role);
  }
}
