import 'package:flutter/material.dart';
import 'package:optima_sync_v2/app/presentation/client/screen/client_screen.dart';
import 'package:optima_sync_v2/app/presentation/connection/screen/connection_screen.dart';
import 'package:optima_sync_v2/app/presentation/employee/screen/employee_screen.dart';
import 'package:optima_sync_v2/app/presentation/home/screens/home_screen.dart';
import 'package:optima_sync_v2/app/presentation/marketing/analytics/screen/marketing_overview_screen.dart';
import 'package:optima_sync_v2/app/presentation/member/screen/team_members_screen.dart';
import 'package:optima_sync_v2/app/presentation/product/screen/product_screen.dart';
import 'package:optima_sync_v2/app/presentation/project/screen/project_screen.dart';
import 'package:optima_sync_v2/app/presentation/reference_data/screen/reference_data_screen.dart';
import 'package:optima_sync_v2/app/presentation/workspaces/screens/workspace_screen.dart';
import 'package:optima_sync_v2/app_drawer.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: AppDrawer(
        selectedItem: selectedPage,
        onTabSelected: (page) => setState(() {
          selectedPage = page;
          Navigator.pop(context);
        }),
      ),
      floatingActionButton: selectedPage == 2 ? FloatingActionButton(child: Icon(Icons.add), onPressed: () {}) : null,
      body: [
        HomeScreen(), // dashboard page
        ProjectScreen(),
        WorkspaceScreen(),
        EmployeeScreen(),
        ConnectionScreen(),
        TeamMembersScreen(),
        ProductScreen(),
        MarketingOverviewPage(),
        ClientScreen(),
        ReferenceDataScreen(),
      ][selectedPage],
    );
  }
}
