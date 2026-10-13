import 'package:flutter/material.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';

class TaskSurface extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const TaskSurface({super.key, required this.child, this.padding = const EdgeInsets.all(18)});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: padding,
    decoration: BoxDecoration(
      color: AppPallete.cardBackground,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppPallete.cardBorder),
    ),
    child: child,
  );
}

class TaskStatusBadge extends StatelessWidget {
  final String status;
  const TaskStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: status == 'Completed' ? AppPallete.successSoft
          : AppPallete.salesPrimarySoft,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(status, maxLines: 1, overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
        color: status == 'Completed' ? AppPallete.success : AppPallete.salesPrimary)),
  );
}

class TaskInfo extends StatelessWidget {
  final String label;
  final String value;
  const TaskInfo({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 160,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(
          color: AppPallete.textSecondary, fontSize: 12, fontWeight: FontWeight.w700,
        )),
        const SizedBox(height: 4),
        Text(value.isEmpty ? '—' : value, style: const TextStyle(color: AppPallete.textPrimary)),
      ],
    ),
  );
}

InputDecoration taskInputDecoration(String label, {IconData? icon}) => InputDecoration(
  labelText: label,
  prefixIcon: icon == null ? null : Icon(icon, size: 20),
  filled: true,
  fillColor: AppPallete.inputFill,
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
);

ButtonStyle taskButtonStyle() => FilledButton.styleFrom(
  backgroundColor: AppPallete.salesPrimary,
  foregroundColor: Colors.white,
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
);

class TaskNotice extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? onRetry;
  const TaskNotice({super.key, required this.icon, required this.title, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) => TaskSurface(
    child: Column(
      children: [
        Icon(icon, size: 42, color: AppPallete.textSecondary),
        const SizedBox(height: 14),
        Text(title, textAlign: TextAlign.center, style: const TextStyle(
          fontSize: 17, fontWeight: FontWeight.w800,
        )),
        const SizedBox(height: 8),
        Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppPallete.textSecondary)),
        if (onRetry != null) ...[
          const SizedBox(height: 16),
          OutlinedButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh), label: const Text('Retry')),
        ],
      ],
    ),
  );
}

Future<bool> confirmTaskRemoval(BuildContext context, String title, String message) async =>
    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    ) ?? false;
