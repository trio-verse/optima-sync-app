import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/member_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/member_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/member/member_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class MemberRepositoryImpl implements MemberRepository {
  final MemberRemoteDataSource remoteDataSource;

  MemberRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<WhateverFailure, List<MemberEntity>>> getMembers() async {
    try {
      final res = await remoteDataSource.getMembers();
      return Right(res);
    } catch (e) {
      return Left(.serverError());
    }
  }

  @override
  Future<Either<WhateverFailure, MemberEntity>> addMember({
    required String email,
    required String role,
  }) async {
    try {
      final res = await remoteDataSource.addMember(email: email, role: role);
      return Right(res);
    } catch (e) {
      return Left(.serverError());
    }
  }

  @override
  Future<Either<WhateverFailure, void>> updateMemberRole({
    required String memberId,
    required String role,
  }) async {
    try {
      final res = await remoteDataSource.updateMemberRole(
        memberId: memberId,
        role: role,
      );
      return Right(res);
    } catch (e) {
      return Left(.serverError());
    }
  }
}
