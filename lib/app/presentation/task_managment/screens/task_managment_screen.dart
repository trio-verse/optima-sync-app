// import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:optima_sync_v2/app/domain/entities/task_mamagement/task_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/task_mamagement/workspace_entity.dart';
import 'package:optima_sync_v2/app/presentation/task_managment/task_managment_details.dart';
import 'package:optima_sync_v2/core/constants/constants.dart';

class TaskManagerScreen extends StatefulWidget {
  final WorkspaceEntity? workspaceEntity;

  const TaskManagerScreen({super.key, required this.workspaceEntity});

  @override
  State<TaskManagerScreen> createState() => _TaskManagerScreenState();
}

class _TaskManagerScreenState extends State<TaskManagerScreen> {
  int _selectedIndex = 2;
  bool? checkboxValue(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return false;
      case TaskStatus.inProgress:
        return null;
      case TaskStatus.completed:
        return true;
    }
  }

  TaskStatus toStatus(bool? val) {
    switch (val) {
      case false:
        return TaskStatus.pending;
      case null:
        return TaskStatus.inProgress;
      case true:
        return TaskStatus.completed;
    }
  }

  bool? changeCheckboxValueFlow(bool? state) {
    if (state == null) {
      return true;
    } else if (state == true) {
      return null;
    }
    return false;
  }

  final TaskEntity taskEntity = TaskEntity(
    id: "id",
    title: "title",
    description: "description",
    status: .completed,
    priority: .high,
    assignedBy: "assignedBy",
  );
  TaskEntity fakeTask = TaskEntity(
    id: '0',
    title: 'title',
    description: 'description',
    status: TaskStatus.pending,
    priority: .high,
    assignedBy: '0',
  );
  final List<TaskEntity> list = [];
  @override
  void initState() {
    super.initState();

    list.add(fakeTask);
  }

  TaskStatus currentStatus = .pending;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Workspace Name")),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => TaskManagerDetails()));
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        selectedItemColor: [Colors.green, Colors.amber, Colors.blue][_selectedIndex],
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.check_circle_rounded), label: "completed"),
          BottomNavigationBarItem(icon: Icon(Icons.hourglass_top_rounded), label: "inProgress"),
          BottomNavigationBarItem(icon: Icon(Icons.access_alarm_outlined), label: "pending"),
        ],
      ),
      body: [
        ListView(
          children: list
              .where((task) => task.status == .completed)
              .map(
                (e) => TaskCard(
                  task: e,
                  onStatusChanged: (newStatus) {
                    onChanged(e, newStatus);
                  },
                  onDelete: () {
                    list.remove(e);
                    setState(() {});
                  },
                ),
              )
              .toList(),
        ),

        ListView(
          children: list
              .where((task) => task.status == .inProgress)
              .map(
                (e) => TaskCard(
                  task: e,
                  onStatusChanged: (newStatus) {
                    onChanged(e, newStatus);
                  },
                  onDelete: () {
                    list.remove(e);
                    setState(() {});
                  },
                ),
              )
              .toList(),
        ),

        ListView(
          children: list
              .where((task) => task.status == .pending)
              .map(
                (e) => TaskCard(
                  task: e,
                  onStatusChanged: (newStatus) {
                    onChanged(e, newStatus);
                  },
                  onDelete: () {
                    list.remove(e);
                    setState(() {});
                  },
                ),
              )
              .toList(),
        ),
      ][_selectedIndex],
    );
  }

  void onChanged(TaskEntity task, TaskStatus newStatus) {
    list.remove(task);
    list.add(task.copyWith(status: newStatus));
    setState(() {});
  }
}

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, required this.onStatusChanged, required this.onDelete});

  final TaskEntity task;
  final void Function(TaskStatus newStatus) onStatusChanged;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: theme.colorScheme.outlineVariant.withAlpha(128)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TaskManagerDetails(task: task))),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Icon, Title/Assignee, and Status Dropdown
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Task Category / Type Icon
                      Container(
                        decoration: BoxDecoration(shape: BoxShape.circle, color: theme.colorScheme.primaryContainer),
                        padding: const EdgeInsets.all(10),
                        child: Icon(Icons.task_alt_rounded, size: 20, color: theme.colorScheme.primary),
                      ),
                      const SizedBox(width: 12),

                      // Title and Assignee
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title, // or task.name depending on your entity
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.person_outline_rounded, size: 14, color: theme.colorScheme.onSurfaceVariant),
                                const SizedBox(width: 4),
                                Text(
                                  "task.assignee", // Update to match your entity field
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Status Selector Popup
                      PopupMenuButton<TaskStatus>(
                        initialValue: task.status,
                        onSelected: onStatusChanged,
                        itemBuilder: (context) => TaskStatus.values.map((status) {
                          return PopupMenuItem(value: status, child: Text(status.name.toCapitalized()));
                        }).toList(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getStatusColor(task.status, theme).withAlpha(30),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: _getStatusColor(task.status, theme).withAlpha(100)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                task.status.name.toCapitalized(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _getStatusColor(task.status, theme),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.arrow_drop_down_rounded, size: 16, color: _getStatusColor(task.status, theme)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Description Section
                  if (task.description.isNotEmpty) ...[
                    const Padding(padding: EdgeInsets.symmetric(vertical: 12.0), child: Divider(height: 1)),
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Text(
                          task.description,
                          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                        IconButton(
                          color: Colors.red,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("delete task?"),
                                content: Text("Are you sure?"),
                                actions: [
                                  OutlinedButton(onPressed: () => Navigator.pop(context), child: Text("cansel")),
                                  ElevatedButton(
                                    onPressed: () {
                                      onDelete();
                                      Navigator.pop(context);
                                    },
                                    child: Text("confirm"),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: Icon(Icons.delete),
                        ),
                        // ElevatedButton.icon(
                        //   onPressed: () {
                        //     Navigator.push(context, MaterialPageRoute(builder: (_) => TaskManagerDetails(task: task)));
                        //   },
                        //   label: Text("Edit"),
                        // ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(TaskStatus status, ThemeData theme) {
    // Customize these based on your TaskStatus enum values
    switch (status.name.toLowerCase()) {
      case 'completed':
      case 'done':
        return Colors.green;
      case 'in_progress':
      case 'inprogress':
        return Colors.orange;
      case 'urgent':
      case 'high':
        return Colors.red;
      default:
        return theme.colorScheme.primary;
    }
  }
}

// Simple string extension for formatting enum names nicely
extension StringExtension on String {
  String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';
}
