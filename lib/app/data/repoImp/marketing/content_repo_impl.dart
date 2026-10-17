import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/marketing/content_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/marketing/campaign_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/marketing/content_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/marketing/content/content_repo.dart';
import 'package:optima_sync_v2/core/errors/failures/failures.dart';

class ContentRepositoryImpl implements ContentRepository {
  final ContentRemoteDataSource remoteDataSource;

  ContentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<WhateverFailure, List<ContentEntity>>> getCampaignContents(
    CampaignEntity campaign,
  ) async {
    try {
      final res = await remoteDataSource.getCampaignContents(campaign);
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<Either<WhateverFailure, ContentEntity>> getContent(
    ContentEntity content,
  ) async {
    try {
      final res = await remoteDataSource.getContent(content);
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<Either<WhateverFailure, ContentEntity>> createContent(
    ContentEntity content,
  ) async {
    try {
      final res = await remoteDataSource.createContent(content);
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<Either<WhateverFailure, ContentEntity>> updateContent(
    ContentEntity content,
  ) async {
    try {
      final res = await remoteDataSource.updateContent(content);
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<Either<WhateverFailure, void>> deleteContent(
    ContentEntity content,
  ) async {
    try {
      final res = await remoteDataSource.deleteContent(content);
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }
}
