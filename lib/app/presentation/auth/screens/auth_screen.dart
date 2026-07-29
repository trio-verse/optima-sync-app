import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/presentation/auth/bloc/auth_bloc.dart';
import 'package:optima_sync_v2/app/presentation/auth/bloc/auth_event.dart';
import 'package:optima_sync_v2/app/presentation/auth/bloc/auth_state.dart';
import 'package:optima_sync_v2/app/presentation/createOrg/screens/createOrg_screen.dart';

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
    final screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Center(
        child: Container(
          width: screenSize.width * .75,
          padding: .all(16),
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: .circular(15),
          ),
          child: Column(
            mainAxisSize: .min,
            spacing: 15,
            children: [
              Text(
                'Sign Up',
                style: TextStyle(fontSize: 30, fontWeight: .bold),
              ),

              Text(
                "Now you do not need a password to access the ERP System. Just enter your email to verify your secure session.",
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  label: Text('Email'),
                  hint: Text('john.doe@gmail.com'),
                  suffixIcon: Icon(Icons.email),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.blue),
                  ),
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
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.blue),
                        ),
                      ),
                    );
                  }
                  return SizedBox();
                },
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is SignUpSuccess) {
                    //
                    //  OTP Submittion
                    //
                    return ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
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
                  //
                  //  Email Submittion
                  //
                  return ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {
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
                      MaterialPageRoute(builder: (c) => CreateOrgScreen()),
                    );
                  }
                },
                child: SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
