import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/presentation/Org/blocs/select_organization_bloc/select_organization_bloc.dart';
import 'package:optima_sync_v2/app/presentation/Org/blocs/select_organization_bloc/select_organization_event.dart';
import 'package:optima_sync_v2/app/presentation/Org/blocs/select_organization_bloc/select_organization_state.dart';
import 'package:optima_sync_v2/app/presentation/Org/screens/create_and_apdate_Org_screen.dart';
import 'package:optima_sync_v2/app/presentation/channel/screen/channel_screen.dart';
import 'package:optima_sync_v2/app/presentation/city/bloc/city_bloc.dart';
import 'package:optima_sync_v2/app/presentation/city/bloc/city_event.dart';
import 'package:optima_sync_v2/app/presentation/city/bloc/city_state.dart';
import 'package:optima_sync_v2/app/presentation/city/screen/city_screen.dart';
import 'package:optima_sync_v2/app/presentation/client/screen/client_screen.dart';
import 'package:optima_sync_v2/app/presentation/industry/screen/industry_screen.dart';
import 'package:optima_sync_v2/app/presentation/product/screen/product_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(iconTheme: IconThemeData()),
      drawer: Drawer(
        width: 280,
        child: Builder(
          builder: (context) {
            return SafeArea(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 25,
                    ),

                    child: Row(
                      children: [
                        Container(
                          width: 45,
                          height: 45,

                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.business,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Optima Sync',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      children: [
                        ListTile(
                          leading: const Icon(Icons.business_outlined),
                          title: const Text('Sales'),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          tileColor: Colors.teal.withOpacity(0.12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          leading: const Icon(
                            Icons.dashboard_outlined,
                            color: Colors.teal,
                          ),
                          title: const Text(
                            'Member',
                            style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.business_outlined),
                          title: const Text('Product'),
                          onTap: () {
                            Navigator.pop(context);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ProductScreen(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.people_outline),
                          title: const Text('Marketing'),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.business_outlined),
                          title: const Text('Clients'),
                          onTap: () {
                            Navigator.pop(context);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ClientScreen(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.security_outlined),
                          title: const Text('industries'),
                          onTap: () {
                            Navigator.pop(context);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const IndustryScreen(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.chat_bubble_outline),
                          title: const Text('Cities'),
                          onTap: () {
                            Navigator.pop(context);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CityScreen(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.tag_outlined),
                          title: const Text('Channels'),
                          onTap: () {
                            Navigator.pop(context);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ChannelScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  ExpansionTile(
                    leading: const Icon(Icons.settings_outlined),
                    title: const Text('Settings'),
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.only(left: 72),
                        leading: const Icon(Icons.person_outline),
                        title: const Text('Edit Profile'),
                        onTap: () {
                          // Navigator.pop(context);
                          // print('before close! ${context.mounted}');
                          Scaffold.of(context).closeDrawer();
                          // print('after close! ${context.mounted}');

                          final bloc = context.read<SelectOrganizationBloc>();

                          bloc.add(LoadOrganizations());

                          // print('after bloc ${context.mounted}');
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (dialogContext) {
                              // print('after showdialog! ${context.mounted}');
                              return BlocProvider.value(
                                value: bloc,
                                child:
                                    BlocListener<
                                      SelectOrganizationBloc,
                                      SelectOrganizationState
                                    >(
                                      listener: (context, state) {
                                        // print(
                                        //   'after listener! ${context.mounted}',
                                        // );
                                        if (state
                                            is SelectOrganizationSuccess) {
                                          final selectedId = state.selectedId;
                                          if (selectedId == null) {
                                            Navigator.pop(dialogContext);

                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'No selected organization',
                                                ),
                                              ),
                                            );
                                            return;
                                          }
                                          final organizations =
                                              state.organizations;
                                          final selectedOrg = organizations
                                              .firstWhere(
                                                (org) => org.id == selectedId,
                                              );
                                          Navigator.pop(dialogContext);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  CreateAndUpdateOrgScreen(
                                                    oldvalue: selectedOrg,
                                                  ),
                                            ),
                                          );
                                        }
                                        if (state
                                            is SelectOrganizationFailure) {
                                          Navigator.pop(dialogContext);
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(state.message),
                                            ),
                                          );
                                        }
                                      },
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                        // child: Text('Hello!!!'),
                                      ),
                                    ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
