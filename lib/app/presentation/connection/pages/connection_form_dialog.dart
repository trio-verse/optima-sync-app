import 'package:flutter/material.dart';

Future<T?> showConnectionFormDialog<T>({
  required BuildContext context,
  required Widget child,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: child,
        ),
      );
    },
  );
}
