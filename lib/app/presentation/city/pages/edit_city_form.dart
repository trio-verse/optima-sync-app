import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/city_entity.dart';
import 'package:optima_sync_v2/app/presentation/city/bloc/city_bloc.dart';
import 'package:optima_sync_v2/app/presentation/city/bloc/city_event.dart';
import 'package:optima_sync_v2/app/presentation/city/bloc/city_state.dart';
import 'package:optima_sync_v2/app/presentation/city/pages/city_list_item.dart'
    show presetCityColors, cityColorToHex, cityHexToColor;
import 'package:optima_sync_v2/core/constants/appPallete.dart';

import 'city_list_item.dart'
    hide cityHexToColor, cityColorToHex, presetCityColors;

class EditCityForm extends StatefulWidget {
  final CityEntity city;

  const EditCityForm({super.key, required this.city});

  @override
  State<EditCityForm> createState() => _EditCityFormState();
}

class _EditCityFormState extends State<EditCityForm> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late Color selectedColor;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.city.name);
    selectedColor = cityHexToColor(widget.city.color);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (formKey.currentState!.validate()) {
      context.read<CityBloc>().add(
        UpdateCitySubmitted(
          id: widget.city.id!,
          name: nameController.text.trim(),
          color: cityColorToHex(selectedColor),
        ),
      );
    }
  }

  Future<void> _pickCustomColor() async {
    final customController = TextEditingController(
      text: cityColorToHex(selectedColor),
    );

    final picked = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        final customKey = GlobalKey<FormState>();

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Custom Color'),
          content: Form(
            key: customKey,
            child: TextFormField(
              controller: customController,
              autofocus: true,
              textCapitalization: TextCapitalization.characters,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Color cannot be empty';
                }

                final colorRegex = RegExp(r'^#[0-9A-Fa-f]{6}$');

                if (!colorRegex.hasMatch(value.trim())) {
                  return 'Enter a valid color like #FF5733';
                }

                return null;
              },
              decoration: const InputDecoration(
                hintText: '#FF5733',
                prefixIcon: Icon(Icons.color_lens_outlined),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPallete.industryPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                if (customKey.currentState!.validate()) {
                  Navigator.pop(dialogContext, customController.text.trim());
                }
              },
              child: const Text('Use Color'),
            ),
          ],
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedColor = cityHexToColor(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: BlocListener<CityBloc, CityState>(
        listener: (context, state) {
          if (state is CitySuccess) {
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<CityBloc, CityState>(
          builder: (context, state) {
            final isSubmitting = state is CityLoading;

            final errorMessage = state is CityFailure ? state.message : null;

            return Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppPallete.cardBorder,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppPallete.industryPrimarySoft,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.edit_outlined,
                          color: AppPallete.industryPrimary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "Edit City",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppPallete.textPrimary,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: isSubmitting
                            ? null
                            : () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close,
                          color: AppPallete.textSecondary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'City Name',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppPallete.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),

                  TextFormField(
                    controller: nameController,
                    autofocus: true,
                    enabled: !isSubmitting,
                    style: const TextStyle(fontSize: 14),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "City name cannot be empty";
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'e.g. Damascus, Berlin, London...',
                      hintStyle: const TextStyle(
                        color: AppPallete.textSecondary,
                        fontSize: 13.5,
                      ),
                      errorText: errorMessage,
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

                  const SizedBox(height: 20),

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
                        cityColorToHex(selectedColor),
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
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      ...presetCityColors.map((color) {
                        final isSelected = color.value == selectedColor.value;

                        return GestureDetector(
                          onTap: isSubmitting
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
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 18,
                                  )
                                : null,
                          ),
                        );
                      }),

                      GestureDetector(
                        onTap: isSubmitting ? null : _pickCustomColor,
                        child: Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppPallete.inputFill,
                            borderRadius: BorderRadius.circular(9),
                            border: Border.all(color: AppPallete.cardBorder),
                          ),
                          child: const Icon(
                            Icons.palette_outlined,
                            size: 18,
                            color: AppPallete.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: isSubmitting
                              ? null
                              : () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppPallete.textPrimary,
                            side: const BorderSide(
                              color: AppPallete.cardBorder,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: isSubmitting ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppPallete.industryPrimary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: isSubmitting
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.check, size: 18),
                          label: Text(
                            isSubmitting ? 'Saving...' : 'Save Changes',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
