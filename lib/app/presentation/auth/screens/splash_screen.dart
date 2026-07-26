import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/presentation/auth/bloc/auth_bloc.dart';
import 'package:optima_sync_v2/app/presentation/auth/bloc/auth_event.dart';
import 'package:optima_sync_v2/app/presentation/auth/bloc/auth_state.dart';
import 'package:optima_sync_v2/app/presentation/auth/screens/auth_screen.dart';
import 'package:optima_sync_v2/app/presentation/home/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(CheckLoginStatus());
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoggedIn) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen()),
          );
        }
        if (state is LoggedOut) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => AuthScreen()),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            spacing: 20,
            mainAxisSize: .min,
            children: [
              Text(
                "Optima Sync",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w800,
                  fontSize: 40,
                ),
              ),
              Text("Precision Enterprise Management"),
              SizedBox(
                width: screenSize.width * 0.3,
                child: LinearProgressIndicator(backgroundColor: Colors.blue),
              ),
              //test
              // CircularProgressIndicator(),
            ],
          ),
          // CircularProgressIndicator(),
        ),
      ),
    );
  }
}
