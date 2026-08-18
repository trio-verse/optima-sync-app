import 'package:get_it/get_it.dart';
import 'package:optima_sync_v2/app/data/repoImp/auth_repo_impl.dart';
import 'package:optima_sync_v2/app/data/repoImp/city_repo_impl.dart';
import 'package:optima_sync_v2/app/data/repoImp/org_repo_impl.dart';
import 'package:optima_sync_v2/app/data/sources/local_data/auth_local_data_source.dart';
import 'package:optima_sync_v2/app/data/sources/local_data/org_local_data_source.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/auth_remote_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:optima_sync_v2/app/data/sources/remote_data/city_remote_data_source.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/org_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/repo/auth/auth_repo.dart';
import 'package:optima_sync_v2/app/domain/repo/city/city_repo.dart';
import 'package:optima_sync_v2/app/domain/repo/createOrg/org_repo.dart';
import 'package:optima_sync_v2/app/domain/usecases/auth_usecases.dart';
import 'package:optima_sync_v2/app/domain/usecases/city_usecases.dart';
import 'package:optima_sync_v2/app/domain/usecases/org_usecases.dart';
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

  // Usecases
  sl.registerLazySingleton(() => AuthUsecases(repo: sl()));

  sl.registerLazySingleton(() => OrgUsecases(repo: sl()));
  sl.registerLazySingleton(() => CityUsecases(repo: sl()));
}
