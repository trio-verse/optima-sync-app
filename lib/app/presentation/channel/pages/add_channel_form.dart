import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:optima_sync_v2/app/presentation/channel/bloc/channel_bloc.dart';
import 'package:optima_sync_v2/app/presentation/channel/bloc/channel_event.dart';
import 'package:optima_sync_v2/app/presentation/channel/bloc/channel_state.dart';
import 'package:optima_sync_v2/app/presentation/channel/pages/channel_list_item.dart'
    show presetChannelColors, channelColorToHex;
import 'package:optima_sync_v2/core/constants/appPallete.dart';

class AddChannelForm extends StatefulWidget {
  const AddChannelForm({super.key});

  @override
  State<AddChannelForm> createState() => _AddChannelFormState();
}

class _AddChannelFormState extends State<AddChannelForm> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  Color selectedColor = AppPallete.industryPrimary;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (formKey.currentState!.validate()) {
      context.read<ChannelBloc>().add(
        AddChannelSubmitted(
          name: nameController.text.trim(),
          color: channelColorToHex(selectedColor),
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
      child: BlocListener<ChannelBloc, ChannelState>(
        listenWhen: (previous, current) {
          return previous is ChannelSubmitting && current is ChannelSuccess;
        },
        listener: (context, state) {
          Navigator.pop(context);
        },
        child: BlocBuilder<ChannelBloc, ChannelState>(
          builder: (context, state) {
            final isSubmitting = state is ChannelSubmitting;

            final errorMessage = state is ChannelFailure ? state.message : null;

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
                          Icons.wifi_tethering,
                          color: AppPallete.industryPrimary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "New Channel",
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
                    'Channel Name',
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
                        return "Channel name cannot be empty";
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'e.g. WhatsApp, Email, Telegram...',
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
                        channelColorToHex(selectedColor),
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
                    children: presetChannelColors.map((color) {
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
                            isSubmitting ? 'Saving...' : 'Save Channel',
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
