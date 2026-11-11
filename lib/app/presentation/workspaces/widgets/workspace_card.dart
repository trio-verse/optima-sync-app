import 'package:flutter/material.dart';
import 'package:optima_sync_v2/app/presentation/task_managment/screens/task_managment_screen.dart';
import 'package:optima_sync_v2/app/presentation/workspaces/screens/workspace_details_screen.dart';

class WorkspaceCard extends StatelessWidget {
  const WorkspaceCard({super.key, required this.onMembersTap});

  final void Function() onMembersTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 3,
      shadowColor: theme.colorScheme.shadow.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (_) => const TaskManagerScreen(workspaceEntity: null))),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Title & Action
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "App Development",
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Manage tasks, sprints, and team updates",
                          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton.filledTonal(
                    onPressed: () =>
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const WorkspaceDetailsScreen())),
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    tooltip: 'Edit Workspace',
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 16.0), child: Divider(height: 1)),

              // Middle Section: Members & Progress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Members Stack
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Text(
                        "Team Members",
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        height: 36,
                        child: Stack(
                          children: [
                            _buildAvatar(0, Colors.red, Icons.person),
                            _buildAvatar(24, Colors.green, Icons.person),
                            _buildAvatar(48, Colors.blue, Icons.person),
                            Positioned(
                              left: 72,
                              child: InkWell(
                                onTap: onMembersTap,
                                borderRadius: BorderRadius.circular(18),
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                                  child: Icon(Icons.add, size: 18, color: theme.colorScheme.onSurfaceVariant),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Progress Indicator Section
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Progress",
                                style: theme.textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              Text("34%", style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: const LinearProgressIndicator(
                              value: 0.34,
                              minHeight: 8,
                              backgroundColor: Colors.black12,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(double left, Color color, IconData icon) {
    return Positioned(
      left: left,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: CircleAvatar(
          radius: 16,
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, size: 16, color: color),
        ),
      ),
    );
  }
}
