import 'package:flutter/material.dart';
import 'package:optima_sync_v2/app/presentation/task_managment/screens/task_managment_screen.dart';
import 'package:optima_sync_v2/app/presentation/workspaces/screens/workspace_details_screen.dart';

class WorkspaceScreen extends StatelessWidget {
  const WorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(children: [WorkspaceCard()]);
  }
}

class WorkspaceCard extends StatelessWidget {
  const WorkspaceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: .all(16),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (_) => TaskManagerScreen(workspaceEntity: null))),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text("app development", style: TextStyle(fontSize: 24, fontWeight: .bold)),
              Text("description"),
              Divider(),
              Row(
                mainAxisAlignment: .spaceEvenly,
                children: [
                  Column(
                    spacing: 10,
                    children: [
                      Text("members", style: TextStyle(fontSize: 20, fontWeight: .bold)),
                      Row(children: [Icon(Icons.dangerous), Icon(Icons.dangerous), Icon(Icons.dangerous)]),
                    ],
                  ),
                  Column(
                    spacing: 10,
                    children: [
                      Text("progress", style: TextStyle(fontSize: 20, fontWeight: .bold)),
                      Text("34%", style: TextStyle(fontSize: 16, fontWeight: .bold)),
                    ],
                  ),
                ],
              ),
              // SizedBox(height: 15),
              Divider(),
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () =>
                        Navigator.push(context, MaterialPageRoute(builder: (_) => WorkspaceDetailsScreen())),
                    label: Text('Edit'),
                    iconAlignment: .start,
                    icon: Icon(Icons.edit),
                  ),
                  // ElevatedButton.icon(
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (_) => TaskManagerScreen(workspaceEntity: null)),
                  //     );
                  //   },
                  //   label: Text('View'),
                  //   iconAlignment: .end,
                  //   icon: Icon(Icons.arrow_forward_ios_sharp),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
