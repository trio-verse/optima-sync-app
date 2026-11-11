import 'package:flutter/material.dart';
import 'package:optima_sync_v2/app/presentation/workspaces/widgets/workspace_card.dart';

class WorkspaceScreen extends StatefulWidget {
  const WorkspaceScreen({super.key});

  @override
  State<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends State<WorkspaceScreen> {
  // final DraggableScrollableController controller = DraggableScrollableController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(borderRadius: .circular(15)),
                child: Row(
                  mainAxisAlignment: .spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text("Active", style: TextStyle(fontWeight: .bold)),
                        Text("50%"),
                      ],
                    ),
                    Container(width: 1, height: 50, color: Colors.black87),
                    Column(
                      children: [
                        Text("Archeved", style: TextStyle(fontWeight: .bold)),
                        Text("50%"),
                      ],
                    ),
                    Container(width: 1, height: 50, color: Colors.black87),

                    Column(
                      children: [
                        Text("Completed", style: TextStyle(fontWeight: .bold)),
                        Text("50%"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            WorkspaceCard(
              onMembersTap: () {
                // controller.animateTo(1, duration: Duration(seconds: 1), curve: Curves.linear);
              },
            ),
          ],
        ),
      ],
    );
  }
}
