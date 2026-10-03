import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:optima_sync_v2/app/domain/entities/industry_entity.dart';
import 'package:optima_sync_v2/app/presentation/industry/bloc/industry_bloc.dart';
import 'package:optima_sync_v2/app/presentation/industry/bloc/industry_event.dart';
import 'package:optima_sync_v2/app/presentation/industry/bloc/industry_state.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';

const List<Color> presetIndustryColors = [
  Color(0xFF2563EB),
  Color(0xFF9333EA),
  Color(0xFFDB2777),
  Color(0xFFF59E0B),
  Color(0xFF16A34A),
  Color(0xFF0891B2),
  Color(0xFF475569),
  Color(0xFFDC2626),
];

String colorToHex(Color color) {
  return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
}

Color hexToColor(String hex) {
  try {
    hex = hex.replaceFirst('#', '');

    if (hex.length == 6) {
      hex = 'FF$hex';
    }

    return Color(int.parse(hex, radix: 16));
  } catch (_) {
    return Colors.grey;
  }
}

class IndustryListItem extends StatefulWidget {
  final IndustryEntity industry;

  final String? activeEditingId;

  final ValueChanged<String?>? onEditingChanged;

  const IndustryListItem({
    super.key,
    required this.industry,
    this.activeEditingId,
    this.onEditingChanged,
  });

  @override
  State<IndustryListItem> createState() => _IndustryListItemState();
}

class _IndustryListItemState extends State<IndustryListItem> {
  void _deleteIndustry() {
    final id = widget.industry.id;

    if (id == null) {
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Delete Industry'),
          content: Text(
            'Are you sure you want to delete "${widget.industry.name}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);

                context.read<IndustryBloc>().add(
                  DeleteIndustrySubmitted(id: id),
                );
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  late final TextEditingController nameController;

  late Color selectedColor;

  bool isEditing = false;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.industry.name);

    selectedColor = hexToColor(widget.industry.color);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _startEditing() {
    setState(() {
      isEditing = true;
      nameController.text = widget.industry.name;
      selectedColor = hexToColor(widget.industry.color);
    });
    widget.onEditingChanged?.call(widget.industry.id);
  }

  void _cancelEditing() {
    setState(() {
      isEditing = false;
      nameController.text = widget.industry.name;
      selectedColor = hexToColor(widget.industry.color);
    });
    widget.onEditingChanged?.call(null);
  }

  void _updateIndustry() {
    final name = nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Industry name cannot be empty')),
      );
      return;
    }

    final id = widget.industry.id;

    if (id == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid industry ID')));
      return;
    }

    context.read<IndustryBloc>().add(
      UpdateIndustrySubmitted(
        id: id,
        name: name,
        color: colorToHex(selectedColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<IndustryBloc, IndustryState>(
      listener: (context, state) {
        if (state is IndustrySuccess && isEditing) {
          setState(() {
            isEditing = false;
          });
          widget.onEditingChanged?.call(null);
        }

        if (state is IndustryFailure && isEditing) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: BlocBuilder<IndustryBloc, IndustryState>(
        builder: (context, state) {
          final isUpdating =
              state is IndustryUpdating &&
              state.updatingId == widget.industry.id;

          final isDeleting =
              state is IndustryDeleting &&
              state.deletingId == widget.industry.id;

          if (isEditing) {
            return _buildEditCard(isUpdating: isUpdating);
          }

          return _buildNormalCard(isDeleting: isDeleting);
        },
      ),
    );
  }

  Widget _buildNormalCard({required bool isDeleting}) {
    final industryColor = hexToColor(widget.industry.color);
    final initial = widget.industry.name.isNotEmpty
        ? widget.industry.name[0].toUpperCase()
        : '?';

    final isLockedByOtherEdit =
        widget.activeEditingId != null &&
        widget.activeEditingId != widget.industry.id;

    final actionsDisabled = isDeleting || isLockedByOtherEdit;

    return Opacity(
      opacity: isDeleting ? 0.5 : (isLockedByOtherEdit ? 0.6 : 1),
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
                color: industryColor,
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
                widget.industry.name,
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
              onTap: actionsDisabled ? null : _startEditing,
            ),
            const SizedBox(width: 8),
            _RoundIconButton(
              icon: Icons.delete_outline,
              iconColor: const Color(0xFFDC2626),
              onTap: actionsDisabled ? null : _deleteIndustry,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditCard({required bool isUpdating}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPallete.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPallete.industryPrimary, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Edit Industry',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppPallete.textPrimary,
            ),
          ),
          const SizedBox(height: 14),

          const Text(
            'Industry Name',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppPallete.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: nameController,
            enabled: !isUpdating,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'e.g. Software, Healthcare...',
              filled: true,
              fillColor: AppPallete.inputFill,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppPallete.industryPrimary,
                  width: 1.4,
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Theme Color',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppPallete.textPrimary,
                ),
              ),
              Text(
                colorToHex(selectedColor),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppPallete.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: presetIndustryColors.map((color) {
              final isSelected = color.value == selectedColor.value;

              return GestureDetector(
                onTap: isUpdating
                    ? null
                    : () {
                        setState(() {
                          selectedColor = color;
                        });
                      },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(
                      color: isSelected
                          ? AppPallete.textPrimary
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : null,
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: isUpdating ? null : _cancelEditing,
                style: TextButton.styleFrom(
                  foregroundColor: AppPallete.textSecondary,
                ),
                child: const Text('Cancel'),
              ),

              const SizedBox(width: 8),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPallete.industryPrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                ),
                onPressed: isUpdating ? null : _updateIndustry,
                child: isUpdating
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Save'),
              ),
            ],
          ),
        ],
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
