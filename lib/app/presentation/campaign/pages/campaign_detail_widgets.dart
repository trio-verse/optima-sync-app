import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:optima_sync_v2/app/domain/entities/content_entity.dart';
import 'package:optima_sync_v2/app/presentation/content/pages/content_card.dart';
import 'package:optima_sync_v2/app/presentation/content/pages/content_status_style.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';

const List<String> kCampaignDetailContentStatuses = [
  'draft',
  'in_review',
  'approved',
  'rejected',
];

const Color kDetailIndigo = Color(0xFF4F46E5);
const Color kDetailIndigoSoft = Color(0xFFEEF2FF);
const Color kDetailGreenSoft = Color(0xFFE7F8F1);
const Color kDetailOrangeSoft = Color(0xFFFFF4DB);
const Color kDetailBlueSoft = AppPallete.salesPrimarySoft;

const _months = [
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

String formatDetailDate(String? raw) {
  if (raw == null || raw.trim().isEmpty) return 'Not set';
  var date = DateTime.tryParse(raw.trim());
  if (date == null) return raw;
  if (date.isUtc) date = date.toLocal();
  return '${_months[date.month - 1]} ${date.day}, ${date.year}';
}

String formatMoney(double value) {
  final isWhole = value == value.roundToDouble();
  final fixed = value.abs().toStringAsFixed(isWhole ? 0 : 2);
  final parts = fixed.split('.');
  final intPart = parts[0].replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
  final sign = value < 0 ? '-' : '';
  return '$sign\$$intPart${parts.length > 1 ? '.${parts[1]}' : ''}';
}

String formatPercent(double value) {
  final isWhole = value == value.roundToDouble();
  return '${value.toStringAsFixed(isWhole ? 0 : 1)}%';
}

class DetailCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const DetailCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppPallete.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPallete.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class DetailInfoItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color background;
  final String label;
  final String value;

  const DetailInfoItem({
    super.key,
    required this.icon,
    required this.color,
    required this.background,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppPallete.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppPallete.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RingGauge extends StatelessWidget {
  final double percent;
  final Color color;
  final double size;

  const RingGauge({
    super.key,
    required this.percent,
    required this.color,
    this.size = 76,
  });

  @override
  Widget build(BuildContext context) {
    final clamped = percent.isNaN ? 0.0 : percent.clamp(0, 100).toDouble();

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(percent: clamped, color: color),
        child: Center(
          child: Text(
            '${clamped.round()}%',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppPallete.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double percent;
  final Color color;

  _RingPainter({required this.percent, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 6.0;
    final center = size.center(Offset.zero);
    final radius = (size.width - stroke) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = const Color(0xFFF1F3F6);
    canvas.drawCircle(center, radius, track);

    final sweep = 2 * math.pi * (percent / 100);
    if (sweep > 0) {
      final arc = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..color = color;
      canvas.drawArc(rect, -math.pi / 2, sweep, false, arc);
    } else {
      canvas.drawCircle(
        Offset(center.dx, center.dy - radius),
        stroke / 2,
        Paint()..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.percent != percent || old.color != color;
}

class MetricCardShell extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Widget body;
  final List<Widget> footer;

  const MetricCardShell({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.body,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return DetailCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: AppPallete.textSecondary,
                  ),
                ),
              ),
              Icon(icon, size: 15, color: iconColor),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(child: Center(child: body)),
          const SizedBox(height: 10),
          const Divider(height: 1, color: AppPallete.cardBorder),
          const SizedBox(height: 8),
          ...footer,
        ],
      ),
    );
  }
}

class MetricFooterRow extends StatelessWidget {
  final String label;
  final String value;

  const MetricFooterRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10.5,
                color: AppPallete.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppPallete.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class DetailPill extends StatelessWidget {
  final String text;
  final Color color;
  final Color background;
  final IconData? icon;

  const DetailPill({
    super.key,
    required this.text,
    required this.color,
    required this.background,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: color),
            const SizedBox(width: 3),
          ],
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailSectionTitle extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String? trailing;

  const DetailSectionTitle({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
              color: AppPallete.textPrimary,
            ),
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: const TextStyle(
              fontSize: 11,
              color: AppPallete.textSecondary,
            ),
          ),
      ],
    );
  }
}

class DetailProgressRow extends StatelessWidget {
  final String label;
  final int count;
  final int total;
  final Color color;

  const DetailProgressRow({
    super.key,
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final fraction = total == 0 ? 0.0 : count / total;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppPallete.textPrimary,
                  ),
                ),
              ),
              Text(
                '$count (${(fraction * 100).round()}%)',
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: AppPallete.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 6,
              backgroundColor: const Color(0xFFF1F3F6),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

class PipelineColumn extends StatelessWidget {
  final String status;
  final List<ContentEntity> items;
  final String campaignId;

  const PipelineColumn({
    super.key,
    required this.status,
    required this.items,
    required this.campaignId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: SizedBox(
        width: 280,
        child: DetailCard(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      ContentStatusStyle.label(status),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppPallete.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F3F6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${items.length}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppPallete.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (items.isEmpty)
                const SizedBox(height: 24)
              else
                ...items.map(
                  (content) =>
                      ContentCard(campaignId: campaignId, content: content),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
