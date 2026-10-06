import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/campaign_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/channel_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/connection_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/product_entity.dart';
import 'package:optima_sync_v2/app/presentation/campaign/bloc/campaign_bloc.dart';
import 'package:optima_sync_v2/app/presentation/campaign/bloc/campaign_event.dart';
import 'package:optima_sync_v2/app/presentation/campaign/bloc/campaign_state.dart';
import 'package:optima_sync_v2/app/presentation/channel/bloc/channel_bloc.dart';
import 'package:optima_sync_v2/app/presentation/channel/bloc/channel_event.dart';
import 'package:optima_sync_v2/app/presentation/channel/bloc/channel_state.dart';
import 'package:optima_sync_v2/app/presentation/connection/bloc/connection_bloc.dart';
import 'package:optima_sync_v2/app/presentation/connection/bloc/connection_state.dart';
import 'package:optima_sync_v2/app/presentation/product/bloc/product_bloc.dart';
import 'package:optima_sync_v2/app/presentation/product/bloc/product_event.dart';
import 'package:optima_sync_v2/app/presentation/product/bloc/product_state.dart';

class ConnectionForm extends StatefulWidget {
  final String title;
  final String submitLabel;
  final ConnectionEntity? initial;
  final void Function(ConnectionEntity connection) onSubmit;
  final bool closeOnSuccess;
  final VoidCallback? onSuccess;
  final bool showStage;

  const ConnectionForm({
    super.key,
    required this.title,
    required this.submitLabel,
    required this.onSubmit,
    this.initial,
    this.closeOnSuccess = true,
    this.onSuccess,
    this.showStage = true,
  });

  @override
  State<ConnectionForm> createState() => _ConnectionFormState();
}

class _ConnectionFormState extends State<ConnectionForm> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController assigneeController;

  String? productId;
  String stage = ConnectionStage.lead;
  String? channelId;
  String? campaignId;
  String? initiatedBy;

  bool _submitAttempted = false;
  bool _submissionRequested = false;

  @override
  void initState() {
    super.initState();

    final initial = widget.initial;

    productId = initial?.productId.isNotEmpty == true
        ? initial!.productId
        : null;
    stage = initial?.stage ?? ConnectionStage.lead;
    channelId = initial?.channelId;
    campaignId = initial?.campaignId;
    initiatedBy = initial?.initiatedBy;

    assigneeController = TextEditingController(text: initial?.assigneeId ?? '');

    context.read<ProductBloc>().add(LoadProducts());
    context.read<ChannelBloc>().add(LoadChannels());
    context.read<CampaignBloc>().add(LoadCampaigns());
  }

  @override
  void dispose() {
    assigneeController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() => _submitAttempted = true);

    final isFormValid = formKey.currentState?.validate() ?? true;

    if (productId == null || !isFormValid) {
      return;
    }

    _submissionRequested = true;
    widget.onSubmit(
      ConnectionEntity(
        id: widget.initial?.id,
        clientId: widget.initial?.clientId,
        productId: productId!,

        stage: stage,

        dealValue: widget.initial?.dealValue,
        channelId: channelId,
        campaignId: campaignId,
        assigneeId: assigneeController.text.trim().isEmpty
            ? null
            : assigneeController.text.trim(),
        initiatedBy: initiatedBy,
      ),
    );
  }

  InputDecoration _decoration(String label, {String? errorText, Widget? icon}) {
    return InputDecoration(
      label: Text(label),
      errorText: errorText,
      prefixIcon: icon,
      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1)),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.blue),
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
      child: BlocListener<ConnectionBloc, ConnectionState>(
        listener: (context, state) {
          if (state is ConnectionFailure) {
            _submissionRequested = false;
          }

          if (state is ConnectionSuccess && _submissionRequested) {
            _submissionRequested = false;
            widget.onSuccess?.call();
            if (widget.closeOnSuccess) {
              Navigator.pop(context);
            }
          }
        },
        child: BlocBuilder<ConnectionBloc, ConnectionState>(
          builder: (context, connectionState) {
            final isSubmitting = connectionState is ConnectionSubmitting;

            final errorMessage = connectionState is ConnectionFailure
                ? connectionState.message
                : null;

            return Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    if (errorMessage != null) ...[
                      Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 10),
                    ],

                    BlocBuilder<ProductBloc, ProductState>(
                      builder: (context, productState) {
                        final products = productState is ProductSuccess
                            ? productState.products
                            : const <ProductEntity>[];

                        final safeProductId =
                            products.any((p) => p.id == productId)
                            ? productId
                            : null;

                        return DropdownButtonFormField<String>(
                          value: safeProductId,
                          decoration: _decoration(
                            "Product *",
                            errorText: _submitAttempted && productId == null
                                ? "Product is required"
                                : null,
                            icon: const Icon(Icons.inventory_2_outlined),
                          ),
                          hint: Text(
                            productState is ProductLoading
                                ? "Loading products..."
                                : "Select a product",
                          ),
                          items: products
                              .where((p) => p.id != null)
                              .map(
                                (product) => DropdownMenuItem(
                                  value: product.id,
                                  child: Text(product.name),
                                ),
                              )
                              .toList(),
                          onChanged: isSubmitting
                              ? null
                              : (value) => setState(() => productId = value),
                        );
                      },
                    ),

                    const SizedBox(height: 15),

                    if (widget.showStage) ...[
                      DropdownButtonFormField<String>(
                        value: stage,
                        decoration: _decoration(
                          "Stage *",
                          icon: const Icon(Icons.trending_up_rounded),
                        ),
                        items: ConnectionStage.values
                            .map(
                              (value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(ConnectionStage.label(value)),
                              ),
                            )
                            .toList(),
                        onChanged: isSubmitting
                            ? null
                            : (value) {
                                if (value != null) {
                                  setState(() => stage = value);
                                }
                              },
                      ),
                      const SizedBox(height: 15),
                    ],

                    BlocBuilder<ChannelBloc, ChannelState>(
                      builder: (context, channelState) {
                        final channels = channelState is ChannelSuccess
                            ? channelState.channels
                            : const <ChannelEntity>[];

                        final safeChannelId =
                            channels.any((c) => c.id == channelId)
                            ? channelId
                            : null;

                        return DropdownButtonFormField<String>(
                          value: safeChannelId,
                          decoration: _decoration(
                            "Channel (optional)",
                            icon: const Icon(Icons.podcasts_outlined),
                          ),
                          hint: Text(
                            channelState is ChannelLoading
                                ? "Loading channels..."
                                : "Select a channel",
                          ),
                          items: channels
                              .where((c) => c.id != null)
                              .map(
                                (channel) => DropdownMenuItem(
                                  value: channel.id,
                                  child: Text(channel.name),
                                ),
                              )
                              .toList(),
                          onChanged: isSubmitting
                              ? null
                              : (value) => setState(() => channelId = value),
                        );
                      },
                    ),

                    const SizedBox(height: 15),

                    BlocBuilder<CampaignBloc, CampaignState>(
                      builder: (context, campaignState) {
                        final campaigns = campaignState is CampaignSuccess
                            ? campaignState.campaigns
                            : const <CampaignEntity>[];

                        final safeCampaignId =
                            campaigns.any((c) => c.id == campaignId)
                            ? campaignId
                            : null;

                        return DropdownButtonFormField<String?>(
                          value: safeCampaignId,
                          decoration: _decoration(
                            "Campaign (optional)",
                            icon: const Icon(Icons.campaign_outlined),
                          ),
                          hint: Text(
                            campaignState is CampaignLoading
                                ? "Loading campaigns..."
                                : "Not linked to a campaign",
                          ),
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Text("Not linked to a campaign"),
                            ),
                            ...campaigns
                                .where((c) => c.id != null)
                                .map(
                                  (campaign) => DropdownMenuItem<String?>(
                                    value: campaign.id,
                                    child: Text(campaign.name),
                                  ),
                                ),
                          ],
                          onChanged: isSubmitting
                              ? null
                              : (value) => setState(() => campaignId = value),
                        );
                      },
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: assigneeController,
                      enabled: !isSubmitting,
                      decoration: _decoration(
                        "Assignee (optional)",
                        icon: const Icon(Icons.person_outline),
                      ),
                    ),

                    const SizedBox(height: 15),

                    DropdownButtonFormField<String?>(
                      value: initiatedBy,
                      decoration: _decoration(
                        "Initiated By (optional)",
                        icon: const Icon(Icons.swap_horiz_outlined),
                      ),
                      hint: const Text("Not specified"),
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text("Not specified"),
                        ),
                        ...InitiatedBy.values.map(
                          (value) => DropdownMenuItem<String?>(
                            value: value,
                            child: Text(InitiatedBy.label(value)),
                          ),
                        ),
                      ],
                      onChanged: isSubmitting
                          ? null
                          : (value) => setState(() => initiatedBy = value),
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
                            : Text(widget.submitLabel),
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
