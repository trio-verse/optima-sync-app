import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/presentation/auth/bloc/auth_bloc.dart';
import 'package:optima_sync_v2/app/presentation/auth/screens/splash_screen.dart';
import 'package:optima_sync_v2/app/presentation/createOrg/bloc/create_org_bloc.dart';
import 'package:optima_sync_v2/service_locator.dart';

void main() async {
  await init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(usecases: sl())),
        BlocProvider(create: (_) => CreateOrgBloc(usecases: sl())),
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
      home: const SplashScreen(),
    );
  }
}
