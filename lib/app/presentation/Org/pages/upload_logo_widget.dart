import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/presentation/Org/blocs/create%20org%20bloc/org_state.dart';
import 'package:optima_sync_v2/app/presentation/navigation/screens/navigation_screen.dart';
import 'package:optima_sync_v2/app/presentation/Org/blocs/bloc/upload_logo_org_bloc.dart';
import 'package:optima_sync_v2/app/presentation/Org/blocs/bloc/upload_logo_org_event.dart';
import 'package:optima_sync_v2/app/presentation/Org/blocs/bloc/upload_logo_org_state.dart';

class UploadLogoWidget extends StatelessWidget {
  const UploadLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UploadLogoOrgBloc, UploadOrgLogoState>(
      listener: (context, state) {
        if (state is UploadOrgLogoSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }

        if (state is UploadOrgLogoFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: BlocBuilder<UploadLogoOrgBloc, UploadOrgLogoState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Organization created successfully",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 30),

              InkWell(
                onTap: state is UploadOrgLogoLoading
                    ? null
                    : () {
                        if (state is CreateOrgSuccess) {
                          context.read<UploadLogoOrgBloc>().add(
                            PickAndUploadLogoEvent(
                              organizationId:
                                  (state as CreateOrgSuccess).organizationId,
                            ),
                          );
                        }
                      },
                child: CircleAvatar(
                  radius: 80,
                  child: state is UploadOrgLogoLoading
                      ? const CircularProgressIndicator()
                      : const Icon(Icons.add_a_photo, size: 45),
                ),
              ),

              const SizedBox(height: 40),

              const Text("Tap the image to upload your organization logo"),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                },
                child: Text("skip"),
              ),
            ],
          );
        },
      ),
    );
  }
}
