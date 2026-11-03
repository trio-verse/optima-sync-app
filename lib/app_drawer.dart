import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/presentation/auth/bloc/auth_bloc.dart';
import 'package:optima_sync_v2/app/presentation/auth/bloc/auth_event.dart';
import 'package:optima_sync_v2/app/presentation/auth/bloc/auth_state.dart';
import 'package:optima_sync_v2/app/presentation/auth/screens/auth_screen.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, this.selectedItem = 0, required this.onTabSelected});

  final int selectedItem;

  final void Function(int page) onTabSelected;

  // Future<void> _navigate(BuildContext context, Widget page, String target) async {
  //   Navigator.pop(context);
  //   if (selectedItem == target) return;
  //   await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  // }

  Future<void> _logout(BuildContext context) async {
    final authBloc = context.read<AuthBloc>();
    Navigator.pop(context);
    authBloc.add(LogoutRequested());

    final result = await authBloc.stream.firstWhere((state) => state is LoggedOut || state is AuthFailure);

    if (!context.mounted) return;

    if (result is LoggedOut) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const AuthScreen()), (route) => false);
      return;
    }

    if (result is AuthFailure) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // width: 286,
      backgroundColor: AppPallete.backgroundColor,
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
                    decoration: BoxDecoration(color: AppPallete.salesPrimary, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.sync_rounded, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('Optima Sync', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
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
                    label: 'Dashboard',
                    selected: selectedItem == 0,
                    onTap: () => onTabSelected(0),
                  ),
                  _DrawerItem(
                    icon: Icons.folder_copy_outlined,
                    label: 'Projects',
                    selected: selectedItem == 1,
                    onTap: () => onTabSelected(1),
                  ),
                  _DrawerItem(
                    icon: Icons.task_alt,
                    label: 'Task Manager',
                    selected: selectedItem == 2,
                    onTap: () => onTabSelected(2),
                  ),
                  _DrawerItem(
                    icon: Icons.badge_outlined,
                    label: 'HR',
                    selected: selectedItem == 3,
                    onTap: () => onTabSelected(3),
                  ),
                  _DrawerItem(
                    icon: Icons.bar_chart_rounded,
                    label: 'Sales',
                    selected: selectedItem == 4,
                    onTap: () => onTabSelected(4),
                  ),
                  _DrawerItem(
                    icon: Icons.people_outline_rounded,
                    label: 'Member',
                    selected: selectedItem == 5,
                    onTap: () => onTabSelected(5),
                  ),
                  _DrawerItem(
                    icon: Icons.inventory_2_outlined,
                    label: 'Product',
                    selected: selectedItem == 6,
                    onTap: () => onTabSelected(6),
                  ),
                  _DrawerItem(
                    icon: Icons.campaign_outlined,
                    label: 'Marketing',
                    selected: selectedItem == 7,
                    onTap: () => onTabSelected(7),
                  ),
                  _DrawerItem(
                    icon: Icons.groups_2_outlined,
                    label: 'Clients',
                    selected: selectedItem == 8,
                    onTap: () => onTabSelected(8),
                  ),
                  _DrawerItem(
                    icon: Icons.storage_outlined,
                    label: 'Reference Data',
                    selected: selectedItem == 9,
                    onTap: () => onTabSelected(9),
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
                  onTap: () => onTabSelected(10),
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
                  dense: false,
                  leading: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 19),
                  title: const Text(
                    'Log out',
                    style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  onTap: () => _logout(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DrawerItem({required this.icon, required this.label, required this.onTap, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: selected ? AppPallete.salesPrimarySoft : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        dense: false,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        leading: Icon(icon, color: selected ? AppPallete.salesPrimary : AppPallete.textSecondary, size: 20),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? AppPallete.salesPrimary : AppPallete.textPrimary,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
