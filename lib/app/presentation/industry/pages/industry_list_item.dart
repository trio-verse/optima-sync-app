import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:optima_sync_v2/app/domain/entities/industry_entity.dart';
import 'package:optima_sync_v2/app/presentation/industry/bloc/industry_bloc.dart';
import 'package:optima_sync_v2/app/presentation/industry/bloc/industry_event.dart';
import 'package:optima_sync_v2/app/presentation/industry/bloc/industry_state.dart';

const List<Color> presetIndustryColors = [
  Color(0xFF2563EB),
  Color(0xFFDC2626),
  Color(0xFF16A34A),
  Color(0xFFF59E0B),
  Color(0xFF9333EA),
  Color(0xFF0891B2),
  Color(0xFFDB2777),
  Color(0xFF475569),
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

  const IndustryListItem({super.key, required this.industry});

  @override
  State<IndustryListItem> createState() => _IndustryListItemState();
}

class _IndustryListItemState extends State<IndustryListItem> {
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
  }

  void _cancelEditing() {
    setState(() {
      isEditing = false;
      nameController.text = widget.industry.name;
      selectedColor = hexToColor(widget.industry.color);
    });
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

          if (isEditing) {
            return _buildEditCard(isUpdating: isUpdating);
          }

          return _buildNormalCard();
        },
      ),
    );
  }

  Widget _buildNormalCard() {
    final industryColor = hexToColor(widget.industry.color);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: industryColor,
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.industry.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    widget.industry.color.toUpperCase(),
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            IconButton(
              onPressed: _startEditing,
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditCard({required bool isUpdating}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: nameController,
              enabled: !isUpdating,
              decoration: const InputDecoration(
                labelText: 'Industry Name',
                hintText: 'Technology',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Industry Color',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 12,
              runSpacing: 12,
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
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.black87 : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : null,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: selectedColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),

                const SizedBox(width: 8),

                Text(
                  colorToHex(selectedColor),
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: isUpdating ? null : _cancelEditing,
                  child: const Text('Cancel'),
                ),

                const SizedBox(width: 8),

                ElevatedButton(
                  onPressed: isUpdating ? null : _updateIndustry,
                  child: isUpdating
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
