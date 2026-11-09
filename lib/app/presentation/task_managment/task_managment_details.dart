import 'package:flutter/material.dart';
import 'package:optima_sync_v2/app/domain/entities/task_mamagement/task_entity.dart';

class TaskManagerDetails extends StatefulWidget {
  const TaskManagerDetails({super.key, this.task});
  final TaskEntity? task;
  @override
  State<TaskManagerDetails> createState() => _TaskManagerDetailsState();
}

class _TaskManagerDetailsState extends State<TaskManagerDetails> {
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _descController = TextEditingController();
  final List<String> listMember = ["osama", "areej", "yazan", "chazal"];
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // _titleController.text = widget.task?.title ?? "";
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Tasks Details', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        titleTextStyle: const TextStyle(color: Colors.black87, fontSize: 18),
      ),
      floatingActionButton: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .end,
        spacing: 12,
        children: [
          FloatingActionButton.small(
            onPressed: () {
              // TODO: Add member action
            },
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
            tooltip: 'Add Member',
            child: const Icon(Icons.person_add),
          ),
          FloatingActionButton.extended(
            onPressed: () {
              // TaskInput input = TaskInput(
              //   title: _titleController.text,
              //   description: _descController.text,
              //   status: "pending",
              //   priority: "high",
              // );
              // TaskUsecases.createTask(input);
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
          spacing: 20,
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
                      labelText: 'task Title',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(borderRadius: .circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  TextField(
                    controller: _descController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'task Description',
                      alignLabelWithHint: true,
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(borderRadius: .circular(12), borderSide: BorderSide.none),
                    ),
                  ),

                  // Icon(Icons.keyboard_arrow_down_outlined),
                  // DropdownButton(items:[

                  // ], onChanged: () {}),
                  // InkWell(child: Icon(Icons.edit),),
                ],
              ),
            ),

            // Extra spacing at the bottom so content isn't blocked by the FABs
            const SizedBox(height: 80),

            DropdownButton(items: [], onChanged: (value) => listMember),
          ],
        ),
      ),
    );
  }
}
