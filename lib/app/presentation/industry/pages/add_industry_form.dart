import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:optima_sync_v2/app/presentation/industry/bloc/industry_bloc.dart';
import 'package:optima_sync_v2/app/presentation/industry/bloc/industry_event.dart';
import 'package:optima_sync_v2/app/presentation/industry/bloc/industry_state.dart';

const Color kDefaultIndustryColor = Color(0xFF2563EB);

const List<Color> _presetColors = [
  kDefaultIndustryColor,
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
        top: 20,
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
                  const Text(
                    "Add Industry",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: nameController,
                    autofocus: true,
                    enabled: !isSubmitting,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Industry name cannot be empty";
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      label: const Text('Industry Name'),
                      hint: const Text('Technology'),
                      suffixIcon: const Icon(Icons.factory_outlined),
                      errorText: errorMessage,
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.blue),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Industry Color',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _presetColors.map((color) {
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
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? Colors.black87
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 20,
                                )
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

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSubmitting ? null : _submit,
                      child: isSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text("Add"),
                    ),
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
