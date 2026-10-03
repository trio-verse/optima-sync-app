import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:optima_sync_v2/app/presentation/industry/bloc/industry_bloc.dart';
import 'package:optima_sync_v2/app/presentation/industry/bloc/industry_event.dart';
import 'package:optima_sync_v2/app/presentation/industry/bloc/industry_state.dart';
import 'package:optima_sync_v2/app/presentation/industry/pages/industry_list_item.dart'
    show presetIndustryColors, colorToHex;
import 'package:optima_sync_v2/core/constants/appPallete.dart';

const Color kDefaultIndustryColor = AppPallete.industryPrimary;

class AddIndustryForm extends StatefulWidget {
  const AddIndustryForm({super.key});

  @override
  State<AddIndustryForm> createState() => _AddIndustryFormState();
}

class _AddIndustryFormState extends State<AddIndustryForm> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  Color selectedColor = kDefaultIndustryColor;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (formKey.currentState!.validate()) {
      context.read<IndustryBloc>().add(
        AddIndustrySubmitted(
          newName: nameController.text.trim(),
          newColor: colorToHex(selectedColor),
        ),
      );
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
      child: BlocListener<IndustryBloc, IndustryState>(
        listener: (context, state) {
          if (state is IndustrySuccess) {
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<IndustryBloc, IndustryState>(
          builder: (context, state) {
            final isSubmitting = state is IndustryAdding;

            final errorMessage = state is IndustryAddFailure
                ? state.message
                : null;

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
                          Icons.add,
                          color: AppPallete.industryPrimary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "Add Industry",
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
                    autofocus: true,
                    enabled: !isSubmitting,
                    style: const TextStyle(fontSize: 14),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Industry name cannot be empty";
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'e.g. Software, Healthcare...',
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
                    }).toList(),
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
                            isSubmitting ? 'Saving...' : 'Save Industry',
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
