import 'package:flutter/material.dart';
import 'package:optima_sync_v2/app/domain/entities/member_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/task_mamagement/workspace_entity.dart';
import 'package:optima_sync_v2/app/presentation/workspaces/screens/workspace_screen.dart';
import 'package:optima_sync_v2/app/presentation/workspaces/widgets/member_card.dart';

class WorkspaceDetailsScreen extends StatefulWidget {
  const WorkspaceDetailsScreen({super.key});
  // final WorkspaceEntity workspaceEntity;

  @override
  State<WorkspaceDetailsScreen> createState() => _WorkspaceDetailsScreenState();
}

class _WorkspaceDetailsScreenState extends State<WorkspaceDetailsScreen> {
  final entity = MemberEntity(id: "1", userId: "userId", role: "role", name: "areej", email: "areej@gmail.com");
  final entity1 = MemberEntity(id: "2", userId: "userId", role: "role", name: "areej", email: "areej@gmail.com");
  final entity2 = MemberEntity(id: "3", userId: "userId", role: "role", name: "areej", email: "areej@gmail.com");

  DateTime _selectedDeadline = DateTime.now();
  final TextEditingController _titleController = TextEditingController(text: 'Project Alpha');
  final TextEditingController _descController = TextEditingController(
    text: 'Redesigning the company workspace dashboard for better mobile responsiveness.',
  );

  Future<void> _pickDeadline() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDeadline = pickedDate;
      });
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Workspace'),
        content: const Text('Are you sure you want to delete this workspace? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Add delete logic here
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedDate = '${_selectedDeadline.year}/${_selectedDeadline.month}/${_selectedDeadline.day}';
    final List<MemberEntity> memberList = [entity, entity2, entity1, entity, entity2, entity1];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Workspace Details', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        titleTextStyle: const TextStyle(color: Colors.black87, fontSize: 18),
        actions: [
          IconButton(
            onPressed: _confirmDelete,
            icon: const Icon(Icons.delete_outline),
            color: Colors.red,
            tooltip: 'Delete Workspace',
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .end,
        spacing: 12,
        children: [
          FloatingActionButton.small(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: SingleChildScrollView(
                    child: Column(children: [...memberList.map((e) => MemberCard(entity: e, isExist: false))]),
                  ),
                ),
              );
            },
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
            tooltip: 'Add Member',
            child: const Icon(Icons.person_add),
          ),
          FloatingActionButton.extended(
            onPressed: () {
              // TODO: Save changes action
            },
            icon: const Icon(Icons.save),
            label: const Text('Save Changes'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            // --- General Info Section ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: .circular(16),
                boxShadow: [BoxShadow(offset: const Offset(0, 2), color: Colors.grey.shade200, blurRadius: 8)],
                border: .all(width: 1, color: Colors.grey.shade100),
              ),
              child: Column(
                crossAxisAlignment: .start,
                spacing: 16,
                children: [
                  const Text('General Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Workspace Title',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(borderRadius: .circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  TextField(
                    controller: _descController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      alignLabelWithHint: true,
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(borderRadius: .circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Row(
                        spacing: 8,
                        children: [
                          const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                          Text('Deadline: $formattedDate', style: const TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                      OutlinedButton.icon(
                        onPressed: _pickDeadline,
                        icon: const Icon(Icons.edit_calendar, size: 16),
                        label: const Text('Change Date'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // --- Members Section Header ---
            Padding(
              padding: const .symmetric(horizontal: 8, vertical: 16),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  const Text('Workspace Members', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('9 Members', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                ],
              ),
            ),

            // --- Members List ---
            // ...List.generate(
            //   3,
            //   (index) => Container(
            //     margin: const EdgeInsets.only(bottom: 12),
            //     padding: const EdgeInsets.all(12),
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: .circular(15),
            //       boxShadow: [BoxShadow(offset: const Offset(0, 2), color: Colors.grey.shade100, blurRadius: 4)],
            //       border: .all(width: 1, color: Colors.grey.shade200),
            //     ),
            //     child: Row(
            //       spacing: 12,
            //       children: [
            //         Container(
            //           decoration: BoxDecoration(color: Colors.blue.withAlpha(40), shape: .circle),
            //           padding: const EdgeInsets.all(10),
            //           child: const Icon(Icons.person, color: Colors.blue),
            //         ),
            //         Expanded(
            //           child: Column(
            //             crossAxisAlignment: .start,
            //             spacing: 2,
            //             children: const [
            //               Text('Sarah Jenkins', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            //               Text('sarah.jenkins@example.com', style: TextStyle(color: Colors.grey, fontSize: 13)),
            //             ],
            //           ),
            //         ),
            //         Container(
            //           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            //           decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: .circular(20)),
            //           child: const Text(
            //             'Admin',
            //             style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black54),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            ...memberList.map(
              (e) => MemberCard(entity: e, isExist: true),
            ), // Extra spacing at the bottom so content isn't blocked by the FABs
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
