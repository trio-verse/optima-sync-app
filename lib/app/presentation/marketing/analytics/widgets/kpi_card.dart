import 'package:flutter/material.dart';

class KpiCard extends StatelessWidget {
  const KpiCard({super.key, required this.title, required this.subTitle, required this.value, required this.icon});
  final String title;
  final String subTitle;
  final String value;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        children: [
          Row(children: [Text(title), Icon(icon)]),
          Expanded(child: Text(value)),
          Text(subTitle),
        ],
      ),
    );
  }
}
