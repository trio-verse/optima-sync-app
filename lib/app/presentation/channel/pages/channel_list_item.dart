import 'package:flutter/material.dart';
import 'package:optima_sync_v2/app/domain/entities/channel_entity.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';

const List<Color> presetChannelColors = [
  AppPallete.industryPrimary,
  Color(0xFF9333EA),
  Color(0xFFDB2777),
  Color(0xFFF59E0B),
  Color(0xFF16A34A),
  Color(0xFF0891B2),
  Color(0xFF475569),
];

String channelColorToHex(Color color) {
  return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
}

Color channelHexToColor(String hex) {
  try {
    hex = hex.replaceFirst('#', '');

    if (hex.length == 3) {
      hex = hex.split('').map((c) => '$c$c').join();
    }

    if (hex.length == 6) {
      hex = 'FF$hex';
    }

    return Color(int.parse(hex, radix: 16));
  } catch (_) {
    return AppPallete.industryPrimary;
  }
}

class ChannelListItem extends StatelessWidget {
  final ChannelEntity channel;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isLoading;

  const ChannelListItem({
    super.key,
    required this.channel,
    this.onEdit,
    this.onDelete,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final channelColor = channelHexToColor(channel.color);
    final initial = channel.name.isNotEmpty
        ? channel.name[0].toUpperCase()
        : '?';

    return Opacity(
      opacity: isLoading ? 0.6 : 1,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppPallete.cardBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppPallete.cardBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: channelColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                initial,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                channel.name,
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                  color: AppPallete.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            _RoundIconButton(
              icon: Icons.edit_outlined,
              onTap: isLoading ? null : onEdit,
            ),
            const SizedBox(width: 8),
            _RoundIconButton(
              icon: Icons.delete_outline,
              iconColor: const Color(0xFFDC2626),
              onTap: isLoading ? null : onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  const _RoundIconButton({required this.icon, this.iconColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: AppPallete.inputFill,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 17,
          color: iconColor ?? AppPallete.textSecondary,
        ),
      ),
    );
  }
}
