import 'package:flutter/material.dart';

class MarketingOverviewSection extends StatelessWidget {
  const MarketingOverviewSection({super.key, required this.onOverviewPressed, required this.onExport});

  final VoidCallback onOverviewPressed;
  final void Function() onExport;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text("Marketing Overview", style: textTheme.headlineLarge),
        Text("subtitle"),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            spacing: 10,
            children: [
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: onOverviewPressed,
                  label: Text("Manage Campaigns"),
                  icon: Icon(Icons.notifications_active),
                ),
              ),
              Expanded(
                flex: 1,
                child: TextButton.icon(onPressed: onExport, label: Text("Export"), icon: Icon(Icons.download_outlined)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
