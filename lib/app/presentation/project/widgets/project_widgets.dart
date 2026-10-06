import 'package:flutter/material.dart';
import 'package:optima_sync_v2/app/presentation/project/theme/project_colors.dart';

const List<String> _kMonths = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String _two(int value) => value.toString().padLeft(2, '0');

String projectDateShort(DateTime date) =>
    '${_kMonths[date.month - 1]} ${date.day}, ${date.year}';

String projectDateIso(DateTime date) =>
    '${date.year}-${_two(date.month)}-${_two(date.day)}';

String projectMonthShort(DateTime date) =>
    _kMonths[date.month - 1].toUpperCase();

String projectTime(DateTime date) {
  final local = date.toLocal();
  final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
  final period = local.hour >= 12 ? 'PM' : 'AM';
  return '$hour:${_two(local.minute)} $period';
}

String projectMoney(double value) {
  final negative = value < 0;
  final parts = value.abs().toStringAsFixed(2).split('.');
  final whole = parts[0].replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
  return '${negative ? '-' : ''}\$$whole.${parts[1]}';
}

String projectInitials(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList();
  if (parts.isEmpty) return '?';
  if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
  return (parts.first.substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
}

class ProjectSurface extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final double radius;
  final bool shadow;
  final VoidCallback? onTap;

  const ProjectSurface({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color = ProjectColors.card,
    this.radius = 22,
    this.shadow = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: shadow ? ProjectColors.shadow : null,
      ),
      child: Material(
        color: color,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

class ProjectIconTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color background;
  final double size;
  final double radius;

  const ProjectIconTile({
    super.key,
    required this.icon,
    this.color = ProjectColors.primary,
    this.background = ProjectColors.primarySoft,
    this.size = 44,
    this.radius = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Icon(icon, color: color, size: size * 0.5),
    );
  }
}

class ProjectPill extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color background;
  final Color foreground;
  final double fontSize;

  const ProjectPill({
    super.key,
    required this.label,
    this.icon,
    this.background = ProjectColors.primarySoft,
    this.foreground = ProjectColors.primary,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize + 3, color: foreground),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: foreground,
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectStatusBadge extends StatelessWidget {
  final String status;
  final bool uppercase;

  const ProjectStatusBadge({
    super.key,
    required this.status,
    this.uppercase = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = ProjectColors.statusStyle(status);
    final label = ProjectColors.statusLabel(status);
    return ProjectPill(
      label: uppercase ? label.toUpperCase() : label,
      background: style.background,
      foreground: style.foreground,
      fontSize: 11,
    );
  }
}

class ProjectProgressBar extends StatelessWidget {
  final double value;
  final Color color;
  final Color background;
  final double height;

  const ProjectProgressBar({
    super.key,
    required this.value,
    this.color = ProjectColors.primary,
    this.background = ProjectColors.primarySoft,
    this.height = 6,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0).toDouble(),
        minHeight: height,
        backgroundColor: background,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}

class ProjectEmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const ProjectEmptyState({
    super.key,
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 20),
      decoration: BoxDecoration(
        color: ProjectColors.tint,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: ProjectColors.muted),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: ProjectColors.muted,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

enum ProjectButtonKind { filled, tonal, danger }

class ProjectButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final IconData? trailingIcon;
  final ProjectButtonKind kind;
  final double height;

  final bool expand;

  const ProjectButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.trailingIcon,
    this.kind = ProjectButtonKind.filled,
    this.height = 52,
    this.expand = false,
  });

  @override
  Widget build(BuildContext context) {
    var background = ProjectColors.primary;
    var foreground = Colors.white;
    if (kind == ProjectButtonKind.tonal) {
      background = ProjectColors.primarySoft;
      foreground = ProjectColors.primary;
    } else if (kind == ProjectButtonKind.danger) {
      background = ProjectColors.dangerSoft;
      foreground = ProjectColors.danger;
    }

    final text = Text(label, maxLines: 1, overflow: TextOverflow.ellipsis);
    final hasTrailing = trailingIcon != null;

    final button = FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        disabledBackgroundColor: background.withValues(alpha: 0.5),
        disabledForegroundColor: foreground.withValues(alpha: 0.6),
        elevation: 0,
        minimumSize: Size(0, height),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
      child: Row(
        mainAxisSize: hasTrailing ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: hasTrailing
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center,
        children: [
          if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
          if (hasTrailing) Expanded(child: text) else text,
          if (hasTrailing) ...[
            const SizedBox(width: 8),
            Icon(trailingIcon, size: 20),
          ],
        ],
      ),
    );

    final decorated = kind == ProjectButtonKind.filled && onPressed != null
        ? DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: ProjectColors.buttonShadow,
            ),
            child: button,
          )
        : button;

    return expand
        ? SizedBox(width: double.infinity, child: decorated)
        : decorated;
  }
}

class ProjectSquareButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color background;
  final Color foreground;
  final double size;
  final bool circle;

  const ProjectSquareButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.background = ProjectColors.primarySoft,
    this.foreground = ProjectColors.primary,
    this.size = 46,
    this.circle = false,
  });

  @override
  Widget build(BuildContext context) {
    final ShapeBorder shape = circle
        ? const CircleBorder()
        : RoundedRectangleBorder(borderRadius: BorderRadius.circular(14));
    final button = Material(
      color: background,
      shape: shape,
      child: InkWell(
        customBorder: shape,
        onTap: onPressed,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, color: foreground, size: size * 0.45),
        ),
      ),
    );
    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }
}

InputDecoration projectInputDecoration(String label, {String? hint}) {
  OutlineInputBorder border(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: color, width: width),
      );

  return InputDecoration(
    labelText: label,
    hintText: hint,
    filled: true,
    fillColor: ProjectColors.tint,
    labelStyle: const TextStyle(color: ProjectColors.muted),
    floatingLabelStyle: const TextStyle(
      color: ProjectColors.primary,
      fontWeight: FontWeight.w600,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: border(Colors.transparent),
    enabledBorder: border(Colors.transparent),
    focusedBorder: border(ProjectColors.primary, 1.5),
    errorBorder: border(ProjectColors.danger),
    focusedErrorBorder: border(ProjectColors.danger, 1.5),
  );
}

class ProjectField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool requiredField;
  final bool numeric;
  final bool integer;
  final int maxLines;

  const ProjectField({
    super.key,
    required this.controller,
    required this.label,
    this.requiredField = false,
    this.numeric = false,
    this.integer = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: numeric
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        style: const TextStyle(
          color: ProjectColors.title,
          fontWeight: FontWeight.w600,
        ),
        decoration: projectInputDecoration(label),
        validator: (value) {
          final text = value?.trim() ?? '';
          if (requiredField && text.isEmpty) return 'Required';
          if (numeric) {
            final number = integer ? int.tryParse(text) : double.tryParse(text);
            if (number == null || number < 0) return 'Enter a valid number';
          }
          return null;
        },
      ),
    );
  }
}

class ProjectDateField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const ProjectDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: InputDecorator(
        decoration: projectInputDecoration(label),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: ProjectColors.title,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: ProjectColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> showProjectConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(
        title,
        style: const TextStyle(
          color: ProjectColors.title,
          fontWeight: FontWeight.w800,
        ),
      ),
      content: Text(
        message,
        style: const TextStyle(color: ProjectColors.body, height: 1.4),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text(
            'Cancel',
            style: TextStyle(color: ProjectColors.muted),
          ),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: ProjectColors.danger,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
