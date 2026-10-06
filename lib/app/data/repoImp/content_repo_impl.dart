import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/content_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/content_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/content/content_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class ContentRepositoryImpl implements ContentRepository {
  final ContentRemoteDataSource remoteDataSource;

  ContentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<WhateverFailure, List<ContentEntity>>> getCampaignContents(
    String campaignId,
  ) async {
    try {
      final res = await remoteDataSource.getCampaignContents(campaignId);
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<Either<WhateverFailure, ContentEntity>> getContent({
    required String campaignId,
    required String id,
  }) async {
    try {
      final res = await remoteDataSource.getContent(campaignId: campaignId, id: id);
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<Either<WhateverFailure, ContentEntity>> createContent({
    required String campaignId,
    required ContentEntity content,
  }) async {
    try {
      final res = await remoteDataSource.createContent(
        campaignId: campaignId,
        content: content,
      );
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<Either<WhateverFailure, ContentEntity>> updateContent({
    required String campaignId,
    required String id,
    required ContentEntity content,
  }) async {
    try {
      final res = await remoteDataSource.updateContent(
        campaignId: campaignId,
        id: id,
        content: content,
      );
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<Either<WhateverFailure, void>> deleteContent({
    required String campaignId,
    required String id,
  }) async {
    try {
      final res = await remoteDataSource.deleteContent(
        campaignId: campaignId,
        id: id,
      );
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }
}
