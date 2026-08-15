import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/presentation/Org/blocs/select_organization_bloc/select_organization_bloc.dart';
import 'package:optima_sync_v2/app/presentation/Org/blocs/select_organization_bloc/select_organization_event.dart';
import 'package:optima_sync_v2/app/presentation/Org/blocs/select_organization_bloc/select_organization_state.dart';

import 'package:optima_sync_v2/app/presentation/Org/screens/create_and_apdate_Org_screen.dart';
import 'package:optima_sync_v2/app/presentation/home/screens/home_screen.dart';

class SelectOrgScreen extends StatefulWidget {
  const SelectOrgScreen({super.key});

  @override
  State<SelectOrgScreen> createState() => _SelectOrgScreenState();
}

class _SelectOrgScreenState extends State<SelectOrgScreen> {
  @override
  void initState() {
    super.initState();

    context.read<SelectOrganizationBloc>().add(LoadOrganizations());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SelectOrganizationBloc, SelectOrganizationState>(
          listener: (context, state) {
            if (state is SelectOrganizationSelected) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HomeScreen()),
              );
            }

            if (state is SelectOrganizationFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Select an organization to continue",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 30),

                Expanded(
                  child:
                      BlocBuilder<
                        SelectOrganizationBloc,
                        SelectOrganizationState
                      >(
                        builder: (context, state) {
                          if (state is SelectOrganizationLoading) {
                            return const SizedBox();
                          }

                          if (state is SelectOrganizationSuccess) {
                            return ListView.builder(
                              itemCount: state.organizations.length,
                              itemBuilder: (context, index) {
                                final org = state.organizations[index];

                                return ListTile(
                                  leading: CircleAvatar(
                                    child: org.logo != null
                                        ? Image(image: NetworkImage(org.logo!))
                                        : const Icon(Icons.business),
                                  ),
                                  title: Text(org.name),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                  ),
                                  onTap: () {
                                    final organizationId = org.id;

                                    if (organizationId == null ||
                                        organizationId.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Invalid organization selected",
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    context.read<SelectOrganizationBloc>().add(
                                      SelectOrganizationSubmitted(
                                        organizationId: organizationId,
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          }

                          if (state is SelectOrganizationFailure) {
                            return Center(child: Text(state.message));
                          }

                          return const SizedBox();
                        },
                      ),
                ),

                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("or"),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CreateAndUpdateOrgScreen(),
                        ),
                      );
                    },
                    child: const Text("Create Organization"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
