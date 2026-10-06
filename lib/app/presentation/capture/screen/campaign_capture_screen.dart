import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/capture_settings_entity.dart';
import 'package:optima_sync_v2/app/presentation/capture/bloc/capture_bloc.dart';
import 'package:optima_sync_v2/app/presentation/capture/bloc/capture_event.dart';
import 'package:optima_sync_v2/app/presentation/capture/bloc/capture_state.dart';
import 'package:optima_sync_v2/app/presentation/capture/screen/public_capture_form_screen.dart';

class CampaignCaptureScreen extends StatefulWidget {
  final String campaignId;
  final String campaignName;

  const CampaignCaptureScreen({
    super.key,
    required this.campaignId,
    required this.campaignName,
  });

  @override
  State<CampaignCaptureScreen> createState() => _CampaignCaptureScreenState();
}

class _CampaignCaptureScreenState extends State<CampaignCaptureScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CaptureBloc>().add(
      LoadCaptureSettings(campaignId: widget.campaignId),
    );
  }

  Future<void> _confirmRegenerate() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Regenerate link?'),
        content: const Text(
          'The current capture link and QR code will stop working immediately. '
          'Anyone with the old link will no longer be able to submit the form.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Regenerate'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      context.read<CaptureBloc>().add(
        RegenerateTokenSubmitted(campaignId: widget.campaignId),
      );
    }
  }

  String? _resolveToken(CaptureSettingsEntity settings) {
    if (settings.token != null) return settings.token;
    final link = settings.link;
    if (link == null) return null;
    final segments = Uri.tryParse(link)?.pathSegments;
    if (segments == null || segments.isEmpty) return null;
    return segments.last;
  }

  void _copyLink(String link) {
    Clipboard.setData(ClipboardData(text: link));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Link copied')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.campaignName} · Lead Capture')),
      body: BlocConsumer<CaptureBloc, CaptureState>(
        listener: (context, state) {
          if (state is CaptureFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is CaptureSuccess && state.message != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message!)));
          }
        },
        builder: (context, state) {
          CaptureSettingsEntity? settings;
          bool busy = false;

          if (state is CaptureSuccess) settings = state.settings;
          if (state is CaptureSubmitting) {
            settings = state.settings;
            busy = true;
          }
          if (state is CaptureFailure) settings = state.settings;

          if (settings == null) {
            if (state is CaptureFailure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: SwitchListTile(
                  title: const Text('Capture form'),
                  subtitle: Text(
                    settings.enabled
                        ? 'Live — accepting submissions'
                        : 'Disabled — link won\'t accept submissions',
                  ),
                  value: settings.enabled,
                  onChanged: busy
                      ? null
                      : (value) {
                          context.read<CaptureBloc>().add(
                            ToggleCaptureSubmitted(
                              campaignId: widget.campaignId,
                              enabled: value,
                            ),
                          );
                        },
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Capture link',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      SelectableText(
                        settings.link ?? 'No link available',
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 12),
                      if (settings.link != null)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => _copyLink(settings!.link!),
                              icon: const Icon(Icons.copy_outlined, size: 18),
                              label: const Text('Copy link'),
                            ),
                            if (_resolveToken(settings) != null)
                              OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PublicCaptureFormScreen(
                                        token: _resolveToken(settings!)!,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.visibility_outlined,
                                  size: 18,
                                ),
                                label: const Text('Preview form'),
                              ),
                          ],
                        ),
                      if (settings.qrCode != null) ...[
                        const Divider(height: 32),
                        Text(
                          'QR code data',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        SelectableText(
                          settings.qrCode!,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: busy ? null : _confirmRegenerate,
                  icon: const Icon(Icons.refresh_outlined),
                  label: const Text('Regenerate link'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
