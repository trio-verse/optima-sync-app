import 'package:get_it/get_it.dart';
import 'package:optima_sync_v2/app/data/repoImp/auth_repo_impl.dart';
import 'package:optima_sync_v2/app/data/repoImp/create_org_repo_impl.dart';
import 'package:optima_sync_v2/app/data/sources/local_data/auth_local_data_source.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/auth_remote_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:optima_sync_v2/app/data/sources/remote_data/create_org_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/repo/auth/auth_repo.dart';
import 'package:optima_sync_v2/app/domain/repo/createOrg/create_org_repo.dart';
import 'package:optima_sync_v2/app/domain/usecases/auth_usecases.dart';
import 'package:optima_sync_v2/app/domain/usecases/craete_org_usecases.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final client = http.Client();

  final storage = await SharedPreferences.getInstance();

  // Data Access Layer
  sl.registerLazySingleton(() => AuthRemoteDataSource(client: client));
  sl.registerLazySingleton(() => AuthLocalDataSource(storage: storage));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // Usecases
  sl.registerLazySingleton(() => AuthUsecases(repo: sl()));

  // Data Access Layer
  sl.registerLazySingleton(() => CreateOrgRemoteDataSource(client: client));

  // Repository
  sl.registerLazySingleton<OrgRepository>(
    () =>
        CreateOrgRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => OrgUsecases(repo: sl()));
}
