import 'package:flutter/material.dart';

class TaskManagerScreen extends StatelessWidget {
  const TaskManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.access_alarm_outlined), label: "completed"),
          BottomNavigationBarItem(icon: Icon(Icons.access_alarm_outlined), label: "inProgress"),
          BottomNavigationBarItem(icon: Icon(Icons.access_alarm_outlined), label: "pending"),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: .spaceBetween,

                      children: [
                        Row(
                          spacing: 12,

                          children: [
                            Container(
                              decoration: BoxDecoration(shape: .circle, color: Colors.blue.withAlpha(40)),

                              child: Padding(padding: const EdgeInsets.all(8.0), child: Icon(Icons.abc)),
                            ),

                            Text("name"),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: .circular(20)),
                          child: const Text(
                            'assignee by',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black54),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: .circular(20)),
                          child: const Text(
                            'Status',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                    Text("description"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
