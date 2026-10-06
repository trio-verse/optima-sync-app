import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/presentation/Org/blocs/select_organization_bloc/select_organization_bloc.dart';
import 'package:optima_sync_v2/app/presentation/Org/blocs/select_organization_bloc/select_organization_event.dart';
import 'package:optima_sync_v2/app/presentation/Org/blocs/select_organization_bloc/select_organization_state.dart';
import 'package:optima_sync_v2/app/presentation/Org/screens/create_and_apdate_Org_screen.dart';
import 'package:optima_sync_v2/app/presentation/analytics/screen/marketing_overview_screen.dart';
import 'package:optima_sync_v2/app/presentation/auth/bloc/auth_bloc.dart';
import 'package:optima_sync_v2/app/presentation/auth/bloc/auth_event.dart';
import 'package:optima_sync_v2/app/presentation/auth/bloc/auth_state.dart';
import 'package:optima_sync_v2/app/presentation/auth/screens/auth_screen.dart';
import 'package:optima_sync_v2/app/presentation/client/screen/client_screen.dart';
import 'package:optima_sync_v2/app/presentation/connection/screen/all_connections_log_screen.dart';
import 'package:optima_sync_v2/app/presentation/employee/screen/employee_screen.dart';
import 'package:optima_sync_v2/app/presentation/home/screens/home_screen.dart';
import 'package:optima_sync_v2/app/presentation/member/screen/team_members_screen.dart';
import 'package:optima_sync_v2/app/presentation/product/screen/product_screen.dart';
import 'package:optima_sync_v2/app/presentation/project/screen/project_screen.dart';
import 'package:optima_sync_v2/app/presentation/reference_data/screen/reference_data_screen.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';

class AppDrawer extends StatelessWidget {
  final String selectedItem;

  const AppDrawer({super.key, this.selectedItem = 'Home'});

  Future<void> _navigate(
    BuildContext context,
    Widget page,
    String target,
  ) async {
    Navigator.pop(context);
    if (selectedItem == target) return;
    await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  Future<void> _logout(BuildContext context) async {
    final authBloc = context.read<AuthBloc>();
    Navigator.pop(context);
    authBloc.add(LogoutRequested());

    final result = await authBloc.stream.firstWhere(
      (state) => state is LoggedOut || state is AuthFailure,
    );

    if (!context.mounted) return;

    if (result is LoggedOut) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AuthScreen()),
        (route) => false,
      );
      return;
    }

    if (result is AuthFailure) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 286,
      backgroundColor: AppPallete.cardBackground,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppPallete.salesPrimary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.sync_rounded, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Optima Sync',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  _DrawerItem(
                    icon: Icons.home_outlined,
                    label: 'Home',
                    selected: selectedItem == 'Home',
                    onTap: () => _navigate(context, const HomeScreen(), 'Home'),
                  ),
                  _DrawerItem(
                    icon: Icons.bar_chart_rounded,
                    label: 'Sales',
                    selected: selectedItem == 'Sales',
                    onTap: () => _navigate(
                      context,
                      const AllConnectionsLogScreen(),
                      'Sales',
                    ),
                  ),
                  _DrawerItem(
                    icon: Icons.people_outline_rounded,
                    label: 'Member',
                    selected: selectedItem == 'Member',
                    onTap: () =>
                        _navigate(context, const TeamMembersScreen(), 'Member'),
                  ),
                  _DrawerItem(
                    icon: Icons.inventory_2_outlined,
                    label: 'Product',
                    selected: selectedItem == 'Product',
                    onTap: () =>
                        _navigate(context, const ProductScreen(), 'Product'),
                  ),
                  _DrawerItem(
                    icon: Icons.campaign_outlined,
                    label: 'Marketing',
                    selected: selectedItem == 'Marketing',
                    onTap: () => _navigate(
                      context,
                      const MarketingOverviewScreen(),
                      'Marketing',
                    ),
                  ),
                  _DrawerItem(
                    icon: Icons.groups_2_outlined,
                    label: 'Clients',
                    selected: selectedItem == 'Clients',
                    onTap: () =>
                        _navigate(context, const ClientScreen(), 'Clients'),
                  ),
                  _DrawerItem(
                    icon: Icons.badge_outlined,
                    label: 'Employees',
                    selected: selectedItem == 'Employees',
                    onTap: () =>
                        _navigate(context, const EmployeeScreen(), 'Employees'),
                  ),
                  _DrawerItem(
                    icon: Icons.storage_outlined,
                    label: 'Reference Data',
                    selected: selectedItem == 'Reference Data',
                    onTap: () => _navigate(
                      context,
                      const ReferenceDataScreen(),
                      'Reference Data',
                    ),
                  ),
                  _DrawerItem(
                    icon: Icons.folder_copy_outlined,
                    label: 'Projects',
                    selected: selectedItem == 'Projects',
                    onTap: () =>
                        _navigate(context, const ProjectScreen(), 'Projects'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            ExpansionTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 70, right: 16),
                  leading: const Icon(Icons.edit_outlined, size: 20),
                  title: const Text('Edit Organization'),
                  onTap: () => _openOrganizationEditor(context),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4F4),
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: const Color(0xFFFFDADA)),
                ),
                child: ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.logout_rounded,
                    color: Colors.redAccent,
                    size: 19,
                  ),
                  title: const Text(
                    'Log out',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.5,
                    ),
                  ),
                  onTap: () => _logout(context),
                ),
              ),
            ),
            const Text(
              'PANEL  v1.0',
              style: TextStyle(
                color: AppPallete.textSecondary,
                fontSize: 9,
                letterSpacing: .8,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _openOrganizationEditor(BuildContext drawerContext) {
    final bloc = drawerContext.read<SelectOrganizationBloc>();
    final navigator = Navigator.of(drawerContext);
    final messenger = ScaffoldMessenger.of(drawerContext);
    final rootContext = navigator.context;
    navigator.pop();
    bloc.add(LoadOrganizations());

    showDialog<void>(
      context: rootContext,
      barrierDismissible: true,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: bloc,
          child: BlocListener<SelectOrganizationBloc, SelectOrganizationState>(
            listener: (context, state) {
              if (state is SelectOrganizationSuccess) {
                final selectedId = state.selectedId;
                Navigator.pop(dialogContext);
                if (selectedId == null) {
                  messenger.showSnackBar(
                    const SnackBar(content: Text('No selected organization')),
                  );
                  return;
                }
                final selectedOrg = state.organizations.firstWhere(
                  (org) => org.id == selectedId,
                );
                navigator.push(
                  MaterialPageRoute(
                    builder: (_) =>
                        CreateAndUpdateOrgScreen(oldvalue: selectedOrg),
                  ),
                );
              }
              if (state is SelectOrganizationFailure) {
                Navigator.pop(dialogContext);
                messenger.showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            child: const Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: selected ? AppPallete.salesPrimarySoft : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        leading: Icon(
          icon,
          color: selected ? AppPallete.salesPrimary : AppPallete.textSecondary,
          size: 20,
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? AppPallete.salesPrimary : AppPallete.textPrimary,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
