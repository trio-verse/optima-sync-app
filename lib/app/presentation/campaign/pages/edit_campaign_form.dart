import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/campaign_entity.dart';
import 'package:optima_sync_v2/app/presentation/campaign/bloc/campaign_bloc.dart';
import 'package:optima_sync_v2/app/presentation/campaign/bloc/campaign_event.dart';
import 'package:optima_sync_v2/app/presentation/campaign/bloc/campaign_state.dart';
import 'package:optima_sync_v2/app/presentation/campaign/pages/campaign_status_style.dart';

class EditCampaignForm extends StatefulWidget {
  final CampaignEntity campaign;

  const EditCampaignForm({super.key, required this.campaign});

  @override
  State<EditCampaignForm> createState() => _EditCampaignFormState();
}

class _EditCampaignFormState extends State<EditCampaignForm> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  late final TextEditingController targetController;
  late final TextEditingController budgetController;
  late final TextEditingController contentCountController;

  DateTime? startDate;
  DateTime? endDate;
  late String status;

  static const _borderedInput = InputDecoration(
    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1)),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Colors.blue),
    ),
  );

  @override
  void initState() {
    super.initState();

    final campaign = widget.campaign;

    nameController = TextEditingController(text: campaign.name);
    descriptionController = TextEditingController(text: campaign.description);
    targetController = TextEditingController(text: campaign.target);
    budgetController = TextEditingController(
      text: campaign.expectedBudget == null
          ? ''
          : campaign.expectedBudget!.toString(),
    );
    contentCountController = TextEditingController(
      text: campaign.estimatedContentCount?.toString() ?? '',
    );

    startDate = campaign.startDate == null
        ? null
        : DateTime.tryParse(campaign.startDate!);
    endDate = campaign.endDate == null
        ? null
        : DateTime.tryParse(campaign.endDate!);
    status = kCampaignStatuses.contains(campaign.status)
        ? campaign.status
        : 'draft';
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    targetController.dispose();
    budgetController.dispose();
    contentCountController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) => date.toIso8601String().split('T').first;

  Future<void> _pickDate({required bool isStart}) async {
    final initial = (isStart ? startDate : endDate) ?? DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    setState(() {
      if (isStart) {
        startDate = picked;
      } else {
        endDate = picked;
      }
    });
  }

  void _submit() {
    if (!formKey.currentState!.validate()) return;

    if (startDate != null && endDate != null && !endDate!.isAfter(startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End date must be after start date')),
      );
      return;
    }

    final budgetText = budgetController.text.trim();
    final contentCountText = contentCountController.text.trim();

    context.read<CampaignBloc>().add(
      UpdateCampaignSubmitted(
        id: widget.campaign.id!,
        campaign: CampaignEntity(
          name: nameController.text.trim(),
          description: descriptionController.text.trim(),
          startDate: startDate == null ? null : _formatDate(startDate!),
          endDate: endDate == null ? null : _formatDate(endDate!),
          expectedBudget: budgetText.isEmpty
              ? null
              : double.tryParse(budgetText),
          estimatedContentCount: contentCountText.isEmpty
              ? null
              : int.tryParse(contentCountText),
          status: status,
          target: targetController.text.trim(),
        ),
      ),
    );
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
      child: BlocListener<CampaignBloc, CampaignState>(
        listener: (context, state) {
          if (state is CampaignSuccess) {
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<CampaignBloc, CampaignState>(
          builder: (context, state) {
            final isSubmitting = state is CampaignLoading;
            final errorMessage = state is CampaignFailure
                ? state.message
                : null;

            return SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Edit Campaign",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: nameController,
                      autofocus: true,
                      enabled: !isSubmitting,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Campaign name cannot be empty";
                        }
                        if (value.trim().length > 255) {
                          return "Name must not exceed 255 characters";
                        }
                        return null;
                      },
                      decoration: _borderedInput.copyWith(
                        label: const Text('Campaign Name'),
                        suffixIcon: const Icon(Icons.campaign_outlined),
                        errorText: errorMessage,
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: descriptionController,
                      enabled: !isSubmitting,
                      minLines: 2,
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Description cannot be empty";
                        }
                        if (value.trim().length > 255) {
                          return "Description must not exceed 255 characters";
                        }
                        return null;
                      },
                      decoration: _borderedInput.copyWith(
                        label: const Text('Description'),
                        prefixIcon: const Icon(Icons.notes_outlined),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: targetController,
                      enabled: !isSubmitting,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Target cannot be empty";
                        }
                        return null;
                      },
                      decoration: _borderedInput.copyWith(
                        label: const Text('Target'),
                        prefixIcon: const Icon(Icons.flag_outlined),
                      ),
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: isSubmitting
                                ? null
                                : () => _pickDate(isStart: true),
                            icon: const Icon(
                              Icons.calendar_today_outlined,
                              size: 18,
                            ),
                            label: Text(
                              startDate == null
                                  ? 'Start Date'
                                  : _formatDate(startDate!),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: isSubmitting
                                ? null
                                : () => _pickDate(isStart: false),
                            icon: const Icon(Icons.event_outlined, size: 18),
                            label: Text(
                              endDate == null
                                  ? 'End Date'
                                  : _formatDate(endDate!),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: budgetController,
                            enabled: !isSubmitting,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty)
                                return null;
                              final budget = double.tryParse(value.trim());
                              if (budget == null || budget < 0) {
                                return "Enter a valid budget";
                              }
                              return null;
                            },
                            decoration: _borderedInput.copyWith(
                              label: const Text('Expected Budget'),
                              prefixIcon: const Icon(
                                Icons.attach_money_outlined,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: contentCountController,
                            enabled: !isSubmitting,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty)
                                return null;
                              final count = int.tryParse(value.trim());
                              if (count == null || count < 0) {
                                return "Enter a valid count";
                              }
                              return null;
                            },
                            decoration: _borderedInput.copyWith(
                              label: const Text('Content Count'),
                              prefixIcon: const Icon(Icons.article_outlined),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: kCampaignStatuses.map((value) {
                        final selected = status == value;
                        final color = CampaignStatusStyle.color(value);
                        return ChoiceChip(
                          label: Text(CampaignStatusStyle.label(value)),
                          selected: selected,
                          onSelected: isSubmitting
                              ? null
                              : (_) => setState(() => status = value),
                          selectedColor: color.withOpacity(.14),
                          labelStyle: TextStyle(
                            color: selected ? color : Colors.grey.shade700,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                          side: BorderSide(
                            color: selected ? color : Colors.grey.shade300,
                          ),
                        );
                      }).toList(),
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
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text("Save Changes"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
