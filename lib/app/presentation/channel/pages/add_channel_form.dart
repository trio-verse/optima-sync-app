import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/presentation/channel/bloc/channel_bloc.dart';
import 'package:optima_sync_v2/app/presentation/channel/bloc/channel_event.dart';
import 'package:optima_sync_v2/app/presentation/channel/bloc/channel_state.dart';

class AddChannelForm extends StatefulWidget {
  const AddChannelForm({super.key});

  @override
  State<AddChannelForm> createState() => _AddChannelFormState();
}

class _AddChannelFormState extends State<AddChannelForm> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (formKey.currentState!.validate()) {
      context.read<ChannelBloc>().add(
        AddChannelSubmitted(name: nameController.text.trim()),
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
      child: BlocListener<ChannelBloc, ChannelState>(
        // Only close the sheet when a submission we triggered (Submitting)
        // has just resolved into Success — not when some unrelated list
        // reload happens to land on Success while this sheet is open.
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
                  const Text(
                    "Add Channel",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: nameController,
                    autofocus: true,
                    enabled: !isSubmitting,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Channel name cannot be empty";
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      label: const Text('Channel Name'),
                      hint: const Text('Social Media'),
                      suffixIcon: const Icon(Icons.tag_outlined),
                      errorText: errorMessage,
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.blue),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

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
