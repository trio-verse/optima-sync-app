import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.factory_outlined),
              title: Text("Industry"),
            ),
          ],
        ),
      ),
      body: Text("HomeScreen"),
      //  NavigationBar(
      //   selectedIndex: state.currentTab.index,
      //   onDestinationSelected: (index) {
      //     context.read<NavigationBloc>().add(
      //       ChangeTab(currentTab: NavigationTab.values[index]),
    );
  }
}
