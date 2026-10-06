import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/presentation/product/bloc/product_bloc.dart';
import 'package:optima_sync_v2/app/presentation/product/bloc/product_event.dart';
import 'package:optima_sync_v2/app/presentation/product/bloc/product_state.dart';
import 'package:optima_sync_v2/app/presentation/product/theme/product_colors.dart';

class AddProductForm extends StatefulWidget {
  const AddProductForm({super.key});

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (formKey.currentState!.validate()) {
      context.read<ProductBloc>().add(
        AddProductSubmitted(
          name: nameController.text.trim(),
          price: double.parse(priceController.text.trim()),
          description: descriptionController.text.trim(),
        ),
      );
    }
  }

  InputDecoration _decoration({
    required String label,
    String? hint,
    Widget? prefixIcon,
    String? errorText,
  }) {
    return InputDecoration(
      label: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: ProductColors.titleText,
        ),
      ),
      hintText: hint,
      hintStyle: const TextStyle(color: ProductColors.subtitleText),
      prefixIcon: prefixIcon,
      errorText: errorText,
      filled: true,
      fillColor: ProductColors.inputFill,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ProductColors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ProductColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ProductColors.danger),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductSuccess) {
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            final isSubmitting = state is ProductLoading;

            final errorMessage = state is ProductFailure ? state.message : null;

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
                        color: ProductColors.cardBorder,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: ProductColors.statBlueBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.inventory_2_outlined,
                          color: ProductColors.statBlueFg,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Add New Product",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ProductColors.titleText,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: nameController,
                    autofocus: true,
                    enabled: !isSubmitting,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Product name cannot be empty";
                      }

                      if (value.trim().length > 255) {
                        return "Product name must not exceed 255 characters";
                      }

                      return null;
                    },
                    decoration: _decoration(
                      label: "Product or Service Name",
                      hint: "e.g., Cloud SaaS Subscription",
                      errorText: errorMessage,
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: priceController,
                    enabled: !isSubmitting,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Product price cannot be empty";
                      }

                      final price = double.tryParse(value.trim());

                      if (price == null || price < 0) {
                        return "Enter a valid price";
                      }

                      return null;
                    },
                    decoration: _decoration(
                      label: "Default Price (\$)",
                      hint: "0.00",
                      prefixIcon: const Icon(
                        Icons.attach_money_outlined,
                        color: ProductColors.subtitleText,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: descriptionController,
                    enabled: !isSubmitting,
                    minLines: 2,
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Product description cannot be empty";
                      }

                      if (value.trim().length > 255) {
                        return "Description must not exceed 255 characters";
                      }

                      return null;
                    },
                    decoration: _decoration(
                      label: "Description & Details",
                      hint: "Write a brief description of the product...",
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: isSubmitting
                              ? null
                              : () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: ProductColors.titleText,
                            side: const BorderSide(
                              color: ProductColors.inputBorder,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: isSubmitting ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ProductColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          icon: isSubmitting
                              ? const SizedBox.shrink()
                              : const Icon(Icons.check, size: 18),
                          label: isSubmitting
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Save Product",
                                  style: TextStyle(fontWeight: FontWeight.w600),
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
