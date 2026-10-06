import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/presentation/Org/blocs/check_selected_org/cubit/check_selected_org_cubit.dart';
import 'package:optima_sync_v2/app/presentation/Org/blocs/select_organization_bloc/select_organization_bloc.dart';
import 'package:optima_sync_v2/app/presentation/auth/bloc/auth_bloc.dart';
import 'package:optima_sync_v2/app/presentation/analytics/bloc/analytics_bloc.dart';
import 'package:optima_sync_v2/app/presentation/campaign/bloc/campaign_bloc.dart';
import 'package:optima_sync_v2/app/presentation/capture/bloc/capture_bloc.dart';
import 'package:optima_sync_v2/app/presentation/capture/bloc/public_capture_bloc.dart';
import 'package:optima_sync_v2/app/presentation/channel/bloc/channel_bloc.dart';
import 'package:optima_sync_v2/app/presentation/city/bloc/city_bloc.dart';
import 'package:optima_sync_v2/app/presentation/client/bloc/client_bloc.dart';
import 'package:optima_sync_v2/app/presentation/connection/bloc/connection_bloc.dart';
import 'package:optima_sync_v2/app/presentation/content/bloc/content_bloc.dart';
import 'package:optima_sync_v2/app/presentation/home/bloc/home_bloc.dart';
import 'package:optima_sync_v2/app/presentation/industry/bloc/industry_bloc.dart';
import 'package:optima_sync_v2/app/presentation/employee/bloc/employee_bloc.dart';
import 'package:optima_sync_v2/app/presentation/member/bloc/member_bloc.dart';
import 'package:optima_sync_v2/app/presentation/product/bloc/product_bloc.dart';
import 'package:optima_sync_v2/app/presentation/project/bloc/project_bloc.dart';
import 'package:optima_sync_v2/splash_screen.dart';
import 'package:optima_sync_v2/app/presentation/Org/blocs/cerate_and_update_org_bloc/create_and_update_org_bloc.dart';
import 'package:optima_sync_v2/app/presentation/Org/blocs/upload_logo_org/upload_logo_org_bloc.dart';
import 'package:optima_sync_v2/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(usecases: sl())),
        BlocProvider(create: (_) => CreateAndUpdateOrgBloc(usecases: sl())),
        BlocProvider(create: (_) => UploadLogoOrgBloc(uploadLogoUseCase: sl())),
        BlocProvider(
          create: (_) => HomeBloc(
            connectionUsecases: sl(),
            clientUsecases: sl(),
            productUsecases: sl(),
            cityUsecases: sl(),
            industryUsecases: sl(),
          ),
        ),
        BlocProvider(create: (_) => SelectOrganizationBloc(usecases: sl())),
        BlocProvider(create: (_) => CheckSelectedOrgCubit(usecases: sl())),
        BlocProvider(create: (_) => CityBloc(usecases: sl())),
        BlocProvider(create: (_) => IndustryBloc(usecases: sl())),
        BlocProvider(create: (_) => MemberBloc(usecases: sl())),
        BlocProvider(create: (_) => ChannelBloc(usecases: sl())),
        BlocProvider(create: (_) => ClientBloc(usecases: sl())),
        BlocProvider(create: (_) => ProductBloc(usecases: sl())),
        BlocProvider(create: (_) => ConnectionBloc(usecases: sl())),
        BlocProvider(create: (_) => CampaignBloc(usecases: sl())),
        BlocProvider(create: (_) => ContentBloc(usecases: sl())),
        BlocProvider(create: (_) => CaptureBloc(usecases: sl())),
        BlocProvider(create: (_) => PublicCaptureBloc(usecases: sl())),
        BlocProvider(create: (_) => AnalyticsBloc(usecases: sl())),
        BlocProvider(create: (_) => EmployeeBloc(usecases: sl())),
        BlocProvider(create: (_) => ProjectBloc(usecases: sl())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "OptimaSync1",
      // theme: AppTheme.lightModeTheme,
      home: SplashScreen(),
    );
  }
}
