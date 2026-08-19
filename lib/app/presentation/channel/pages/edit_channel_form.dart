import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/channel_entity.dart';
import 'package:optima_sync_v2/app/presentation/channel/bloc/channel_bloc.dart';
import 'package:optima_sync_v2/app/presentation/channel/bloc/channel_event.dart';
import 'package:optima_sync_v2/app/presentation/channel/bloc/channel_state.dart';

class EditChannelForm extends StatefulWidget {
  final ChannelEntity channel;

  const EditChannelForm({super.key, required this.channel});

  @override
  State<EditChannelForm> createState() => _EditChannelFormState();
}

class _EditChannelFormState extends State<EditChannelForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.channel.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<ChannelBloc>().add(
      UpdateChannelSubmitted(
        id: widget.channel.id!,
        name: _nameController.text,
        color: widget.channel.color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChannelBloc, ChannelState>(
      listener: (context, state) {
        if (state is ChannelSuccess) {
          Navigator.of(context).pop();
        }

        if (state is ChannelFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Edit Channel',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Channel name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Channel name cannot be empty';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              BlocBuilder<ChannelBloc, ChannelState>(
                builder: (context, state) {
                  final isSubmitting = state is ChannelSubmitting;

                  return ElevatedButton(
                    onPressed: isSubmitting ? null : _submit,
                    child: isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
