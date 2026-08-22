import 'package:get_it/get_it.dart';
import 'package:optima_sync_v2/app/data/repoImp/auth_repo_impl.dart';
import 'package:optima_sync_v2/app/data/repoImp/channel_repo_impl.dart';
import 'package:optima_sync_v2/app/data/repoImp/city_repo_impl.dart';
import 'package:optima_sync_v2/app/data/repoImp/client_repo_impl.dart';
import 'package:optima_sync_v2/app/data/repoImp/industry_repo_impl.dart';
import 'package:optima_sync_v2/app/data/repoImp/org_repo_impl.dart';
import 'package:optima_sync_v2/app/data/repoImp/product_repo_impl.dart';
import 'package:optima_sync_v2/app/data/sources/local_data/auth_local_data_source.dart';
import 'package:optima_sync_v2/app/data/sources/local_data/org_local_data_source.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/auth_remote_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:optima_sync_v2/app/data/sources/remote_data/channel_remote_data_source.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/city_remote_data_source.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/client_remote_data_source.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/industry_remote_data_source.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/org_remote_data_source.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/product_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/repo/auth/auth_repo.dart';
import 'package:optima_sync_v2/app/domain/repo/channel/channel_repo.dart';
import 'package:optima_sync_v2/app/domain/repo/city/city_repo.dart';
import 'package:optima_sync_v2/app/domain/repo/client/client_repo.dart';
import 'package:optima_sync_v2/app/domain/repo/createOrg/org_repo.dart';
import 'package:optima_sync_v2/app/domain/repo/industry/industry_repo.dart';
import 'package:optima_sync_v2/app/domain/repo/product/product_repo.dart';
import 'package:optima_sync_v2/app/domain/usecases/auth_usecases.dart';
import 'package:optima_sync_v2/app/domain/usecases/channel_usecases.dart';
import 'package:optima_sync_v2/app/domain/usecases/city_usecases.dart';
import 'package:optima_sync_v2/app/domain/usecases/client_usecases.dart';
import 'package:optima_sync_v2/app/domain/usecases/industry_usecases.dart';
import 'package:optima_sync_v2/app/domain/usecases/org_usecases.dart';
import 'package:optima_sync_v2/app/domain/usecases/product_usecases.dart';
import 'package:optima_sync_v2/core/network/http_client_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final client = http.Client();

  final storage = await SharedPreferences.getInstance();
  sl.registerLazySingleton(
    () => HttpClientHelper(storage: storage, client: client),
  );

  // Data Access Layer
  sl.registerLazySingleton(() => AuthRemoteDataSource(client: client));
  sl.registerLazySingleton(() => AuthLocalDataSource(storage: storage));
  sl.registerLazySingleton(() => OrgLocalDataSource(storage: storage));
  sl.registerLazySingleton(() => CreateOrgRemoteDataSource(client: sl()));
  sl.registerLazySingleton(
    () => CityRemoteDataSource(client: sl(), orgLocalDataSource: sl()),
  );
  sl.registerLazySingleton(
    () => IndustryRemoteDataSource(client: sl(), orgLocalDataSource: sl()),
  );
  sl.registerLazySingleton(
    () => ChannelRemoteDataSource(client: sl(), orgLocalDataSource: sl()),
  );
  sl.registerLazySingleton(
    () => ClientRemoteDataSource(client: sl(), orgLocalDataSource: sl()),
  );
  sl.registerLazySingleton(
    () => ProductRemoteDataSource(client: sl(), orgLocalDataSource: sl()),
  );
  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
  sl.registerLazySingleton<OrgRepository>(
    () =>
        CreateOrgRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
  sl.registerLazySingleton<CityRepository>(
    () => CityRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<IndustryRepository>(
    () => IndustryRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ChannelRepository>(
    () => ChannelRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ClientRepository>(
    () => ClientRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl()),
  );
  // Usecases
  sl.registerLazySingleton(() => AuthUsecases(repo: sl()));

  sl.registerLazySingleton(() => OrgUsecases(repo: sl()));
  sl.registerLazySingleton(() => CityUsecases(repo: sl()));
  sl.registerLazySingleton(() => IndustryUsecases(repo: sl()));
  sl.registerLazySingleton(() => ChannelUsecases(repo: sl()));
  sl.registerLazySingleton(() => ClientUsecases(repo: sl()));
  sl.registerLazySingleton(() => ProductUsecases(repo: sl()));
}
