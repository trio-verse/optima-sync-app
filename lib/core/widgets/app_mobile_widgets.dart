import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';

class AppSurface extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const AppSurface({super.key, required this.child, this.padding = const EdgeInsets.all(16)});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: padding,
    decoration: BoxDecoration(
      color: AppPallete.cardBackground,
      borderRadius: BorderRadius.circular(AppPallete.cardRadius),
      border: Border.all(color: AppPallete.cardBorder),
    ),
    child: child,
  );
}

class AppFieldRow extends StatelessWidget {
  final List<Widget> children;
  const AppFieldRow({super.key, required this.children});

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) {
    if (constraints.maxWidth < 480 || MediaQuery.textScalerOf(context).scale(14) > 20) {
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        for (var index = 0; index < children.length; index++) ...[
          if (index > 0) const SizedBox(height: 12),
          children[index],
        ],
      ]);
    }
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      for (var index = 0; index < children.length; index++) ...[
        if (index > 0) const SizedBox(width: 12),
        Expanded(child: children[index]),
      ],
    ]);
  });
}

class AppMobileDialog extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Color? surfaceTintColor;
  final EdgeInsets? insetPadding;
  final ShapeBorder? shape;
  final Clip clipBehavior;

  const AppMobileDialog({super.key, required this.child,
    this.backgroundColor, this.surfaceTintColor, this.insetPadding,
    this.shape, this.clipBehavior = Clip.antiAlias});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final mobile = media.size.width < AppPallete.mobileBreakpoint;
    final availableHeight = math.max(0.0,
      media.size.height - media.viewInsets.bottom - media.padding.vertical - 40);
    return Dialog(
      alignment: mobile ? Alignment.bottomCenter : Alignment.center,
      backgroundColor: backgroundColor ?? AppPallete.cardBackground,
      surfaceTintColor: surfaceTintColor ?? Colors.transparent,
      insetPadding: mobile ? const EdgeInsets.fromLTRB(12, 20, 12, 12)
          : insetPadding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: mobile ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
          : shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: clipBehavior,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: mobile ? media.size.width - 24 : 680, maxHeight: availableHeight),
        child: child,
      ),
    );
  }
}

class AppMetricGrid extends StatelessWidget {
  final List<Widget> children;
  const AppMetricGrid({super.key, required this.children});

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) {
    final largeText = MediaQuery.textScalerOf(context).scale(14) > 20;
    final preferred = largeText || constraints.maxWidth < 280 ? 1 : constraints.maxWidth >= 760 ? 4 : 2;
    final columns = math.max(1, math.min(children.length, preferred));
    final width = (constraints.maxWidth - 12 * (columns - 1)) / columns;
    return Wrap(spacing: 12, runSpacing: 12,
      children: children.map((child) => SizedBox(width: width, child: child)).toList());
  });
}

class AppMetricTile extends StatelessWidget {
  final String label;
  final String value;
  final String? caption;
  final IconData icon;
  final double? progress;
  final Color color;
  const AppMetricTile({super.key, required this.label, required this.value,
    required this.icon, this.caption, this.progress, this.color = AppPallete.primary});

  @override
  Widget build(BuildContext context) => AppSurface(
    padding: const EdgeInsets.all(14),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, size: 22, color: color),
      const SizedBox(height: 10),
      Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppPallete.textPrimary)),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(fontSize: 13, color: AppPallete.textSecondary)),
      if (caption != null) ...[
        const SizedBox(height: 4),
        Text(caption!, style: const TextStyle(fontSize: 12, color: AppPallete.textSecondary)),
      ],
      if (progress != null) ...[
        const SizedBox(height: 10),
        ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(
          value: progress, minHeight: 3, color: color, backgroundColor: AppPallete.primarySoft)),
      ],
    ]),
  );
}
