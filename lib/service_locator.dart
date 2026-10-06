import 'package:get_it/get_it.dart';
import 'package:optima_sync_v2/app/data/repoImp/analytics_repo_impl.dart';
import 'package:optima_sync_v2/app/data/repoImp/auth_repo_impl.dart';
import 'package:optima_sync_v2/app/data/repoImp/campaign_repo_impl.dart';
import 'package:optima_sync_v2/app/data/repoImp/capture_repo_impl.dart';
import 'package:optima_sync_v2/app/data/repoImp/project_repo_impl.dart';
import 'package:optima_sync_v2/app/data/repoImp/public_capture_repo_impl.dart';
import 'package:optima_sync_v2/app/data/repoImp/channel_repo_impl.dart';
import 'package:optima_sync_v2/app/data/repoImp/city_repo_impl.dart';
import 'package:optima_sync_v2/app/data/repoImp/client_repo_impl.dart';
import 'package:optima_sync_v2/app/data/repoImp/connection_repo_impl.dart';
import 'package:optima_sync_v2/app/data/repoImp/content_repo_impl.dart';
import 'package:optima_sync_v2/app/data/repoImp/employee_repo_impl.dart';
import 'package:optima_sync_v2/app/data/repoImp/industry_repo_impl.dart';
import 'package:optima_sync_v2/app/data/repoImp/member_repo_impl.dart';
import 'package:optima_sync_v2/app/data/repoImp/org_repo_impl.dart';
import 'package:optima_sync_v2/app/data/repoImp/product_repo_impl.dart';
import 'package:optima_sync_v2/app/data/sources/local_data/auth_local_data_source.dart';
import 'package:optima_sync_v2/app/data/sources/local_data/org_local_data_source.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/auth_remote_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:optima_sync_v2/app/data/sources/remote_data/analytics_remote_data_source.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/campaign_remote_data_source.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/capture_remote_data_source.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/public_capture_remote_data_source.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/channel_remote_data_source.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/city_remote_data_source.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/client_remote_data_source.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/connection_remote_data_source.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/content_remote_data_source.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/employee_remote_data_source.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/industry_remote_data_source.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/member_remote_data_source.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/org_remote_data_source.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/product_remote_data_source.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/project_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/repo/analytics/analytics_repo.dart';
import 'package:optima_sync_v2/app/domain/repo/auth/auth_repo.dart';
import 'package:optima_sync_v2/app/domain/repo/campaign/campaign_repo.dart';
import 'package:optima_sync_v2/app/domain/repo/capture/capture_repo.dart';
import 'package:optima_sync_v2/app/domain/repo/project/project_repo.dart';
import 'package:optima_sync_v2/app/domain/repo/public_capture/public_capture_repo.dart';
import 'package:optima_sync_v2/app/domain/repo/channel/channel_repo.dart';
import 'package:optima_sync_v2/app/domain/repo/city/city_repo.dart';
import 'package:optima_sync_v2/app/domain/repo/client/client_repo.dart';
import 'package:optima_sync_v2/app/domain/repo/connection/connection_repo.dart';
import 'package:optima_sync_v2/app/domain/repo/content/content_repo.dart';
import 'package:optima_sync_v2/app/domain/repo/employee/employee_repo.dart';
import 'package:optima_sync_v2/app/domain/repo/createOrg/org_repo.dart';
import 'package:optima_sync_v2/app/domain/repo/industry/industry_repo.dart';
import 'package:optima_sync_v2/app/domain/repo/member/member_repo.dart';
import 'package:optima_sync_v2/app/domain/repo/product/product_repo.dart';
import 'package:optima_sync_v2/app/domain/usecases/analytics_usecases.dart';
import 'package:optima_sync_v2/app/domain/usecases/auth_usecases.dart';
import 'package:optima_sync_v2/app/domain/usecases/campaign_usecases.dart';
import 'package:optima_sync_v2/app/domain/usecases/capture_usecases.dart';
import 'package:optima_sync_v2/app/domain/usecases/project_usecases.dart';
import 'package:optima_sync_v2/app/domain/usecases/public_capture_usecases.dart';
import 'package:optima_sync_v2/app/domain/usecases/channel_usecases.dart';
import 'package:optima_sync_v2/app/domain/usecases/city_usecases.dart';
import 'package:optima_sync_v2/app/domain/usecases/client_usecases.dart';
import 'package:optima_sync_v2/app/domain/usecases/connection_usecases.dart';
import 'package:optima_sync_v2/app/domain/usecases/content_usecases.dart';
import 'package:optima_sync_v2/app/domain/usecases/employee_usecases.dart';
import 'package:optima_sync_v2/app/domain/usecases/industry_usecases.dart';
import 'package:optima_sync_v2/app/domain/usecases/member_usecases.dart';
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
    () => MemberRemoteDataSource(client: sl(), orgLocalDataSource: sl()),
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
  sl.registerLazySingleton(
    () => ConnectionRemoteDataSource(client: sl(), orgLocalDataSource: sl()),
  );
  sl.registerLazySingleton(
    () => CampaignRemoteDataSource(client: sl(), orgLocalDataSource: sl()),
  );
  sl.registerLazySingleton(
    () => ContentRemoteDataSource(client: sl(), orgLocalDataSource: sl()),
  );
  sl.registerLazySingleton(
    () => CaptureRemoteDataSource(client: sl(), orgLocalDataSource: sl()),
  );
  sl.registerLazySingleton(() => PublicCaptureRemoteDataSource(client: client));
  sl.registerLazySingleton(
    () => AnalyticsRemoteDataSource(client: sl(), orgLocalDataSource: sl()),
  );
  sl.registerLazySingleton(
    () => EmployeeRemoteDataSource(client: sl(), orgLocalDataSource: sl()),
  );
  sl.registerLazySingleton(
    () => ProjectRemoteDataSource(client: sl(), orgLocalDataSource: sl()),
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
  sl.registerLazySingleton<MemberRepository>(
    () => MemberRepositoryImpl(remoteDataSource: sl()),
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
  sl.registerLazySingleton<ConnectionRepository>(
    () => ConnectionRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<CampaignRepository>(
    () => CampaignRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ContentRepository>(
    () => ContentRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<CaptureRepository>(
    () => CaptureRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<PublicCaptureRepository>(
    () => PublicCaptureRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<AnalyticsRepository>(
    () => AnalyticsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<EmployeeRepository>(
    () => EmployeeRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ProjectRepository>(
    () => ProjectRepositoryImpl(remoteDataSource: sl()),
  );
  // Usecases
  sl.registerLazySingleton(() => AuthUsecases(repo: sl()));
  sl.registerLazySingleton(() => OrgUsecases(repo: sl()));
  sl.registerLazySingleton(() => CityUsecases(repo: sl()));
  sl.registerLazySingleton(() => IndustryUsecases(repo: sl()));
  sl.registerLazySingleton(() => MemberUsecases(repo: sl()));
  sl.registerLazySingleton(() => ChannelUsecases(repo: sl()));
  sl.registerLazySingleton(() => ClientUsecases(repo: sl()));
  sl.registerLazySingleton(() => ProductUsecases(repo: sl()));
  sl.registerLazySingleton(() => ConnectionUsecases(repo: sl()));
  sl.registerLazySingleton(() => CampaignUsecases(repo: sl()));
  sl.registerLazySingleton(() => ContentUsecases(repo: sl()));
  sl.registerLazySingleton(() => CaptureUsecases(repo: sl()));
  sl.registerLazySingleton(() => PublicCaptureUsecases(repo: sl()));
  sl.registerLazySingleton(() => AnalyticsUsecases(repo: sl()));
  sl.registerLazySingleton(() => EmployeeUsecases(repo: sl()));
  sl.registerLazySingleton(() => ProjectUsecases(repo: sl()));
}
