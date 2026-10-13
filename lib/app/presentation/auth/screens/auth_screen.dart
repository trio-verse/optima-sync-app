import 'package:flutter/material.dart';
import 'package:optima_sync_v2/core/constants/theme.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/presentation/Org/screens/select_org_screen.dart';
import 'package:optima_sync_v2/app/presentation/auth/bloc/auth_bloc.dart';
import 'package:optima_sync_v2/app/presentation/auth/bloc/auth_event.dart';
import 'package:optima_sync_v2/app/presentation/auth/bloc/auth_state.dart';
import 'package:optima_sync_v2/app/presentation/Org/screens/create_and_apdate_Org_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final emailController = TextEditingController();
  final codeController = TextEditingController();

  bool isCodeSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Center(child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppPallete.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppPallete.cardBorder),
          ),
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 15,
            children: [
              Text(
                'Sign Up',
                style: TextStyle(fontSize: 24, fontWeight: .bold),
              ),

              Text(
                "Now you do not need a password to access the ERP System. Just enter your email to verify your secure session.",
              ),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  label: Text('Email'),
                  hint: Text('john.doe@gmail.com'),
                  suffixIcon: Icon(Icons.email),
                  enabledBorder: AppTheme.inputBorder,
                  focusedBorder: AppTheme.focusedInputBorder,
                ),
              ),

              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is SignUpSuccess) {
                    return TextField(
                      controller: codeController,
                      decoration: InputDecoration(
                        label: Text('OTP'),
                        hint: Text('xxx-xxx'),
                        suffixIcon: Icon(Icons.password),
                        enabledBorder: AppTheme.inputBorder,
                        focusedBorder: AppTheme.focusedInputBorder,
                      ),
                    );
                  }
                  return SizedBox();
                },
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is SignUpSuccess) {
                    return ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPallete.primary,
                      ),
                      onPressed: () {
                        print(isCodeSent);
                        context.read<AuthBloc>().add(
                          VerifyCodeSubmitted(
                            email: emailController.text,
                            code: codeController.text,
                          ),
                        );
                      },
                      icon: state is AuthLoading
                          ? SizedBox(
                              width: 10,
                              height: 10,
                              child: Center(
                                child: SizedBox(
                                  width: 10,
                                  height: 10,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            )
                          : SizedBox(),
                      label: Text(
                        'Verify OTP',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPallete.primary,
                    ),
                    onPressed: () {
                      print(' SEND BUTTON PRESSED');
                      context.read<AuthBloc>().add(
                        SignUpSubmitted(email: emailController.text),
                      );
                    },
                    icon: state is AuthLoading
                        ? SizedBox(
                            width: 10,
                            height: 10,
                            child: Center(
                              child: SizedBox(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          )
                        : SizedBox(),
                    label: Text(
                      'Send Verification Code',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
              BlocListener<AuthBloc, AuthState>(
                listener: (previous, current) {
                  if (current is VerifySuccess) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (c) => SelectOrgScreen()),
                    );
                  }
                },
                child: SizedBox(),
              ),
            ],
          ),
        ),
      )))),
    );
  }
}
