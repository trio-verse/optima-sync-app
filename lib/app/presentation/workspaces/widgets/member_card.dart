import 'package:flutter/material.dart';
import 'package:optima_sync_v2/app/domain/entities/member_entity.dart';

class MemberCard extends StatelessWidget {
  const MemberCard({super.key, required this.entity, required this.isExist});

  final MemberEntity entity;
  final bool isExist;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: .all(5),
      padding: .symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        // color: Colors.amber,
        borderRadius: .circular(10),
        border: BoxBorder.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Column(
            children: [
              Row(
                mainAxisSize: .min,
                // mainAxisAlignment: .spaceEvenly,
                children: [
                  Text("${entity.name}", style: TextStyle(fontSize: 20, fontWeight: .bold)),
                  Text("  (${entity.role})", style: TextStyle(color: Colors.grey.shade700)),
                ],
              ),

              Text("${entity.email}", style: TextStyle(color: Colors.grey.shade700)),
            ],
          ),
          if (!isExist)
            ElevatedButton(
              onPressed: () {},
              child: Icon(Icons.add, size: 25),
              style: ElevatedButton.styleFrom(padding: .zero),
            ),
          if (isExist) IconButton(onPressed: () {}, icon: Icon(Icons.delete), color: Colors.red),
        ],
      ),
    );
  }
}
