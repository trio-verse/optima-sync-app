import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/client_entity.dart';
import 'package:optima_sync_v2/app/presentation/client/bloc/client_bloc.dart';
import 'package:optima_sync_v2/app/presentation/client/bloc/client_event.dart';

import 'client_form.dart';

class EditClientForm extends StatelessWidget {
  final ClientEntity client;

  const EditClientForm({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return ClientForm(
      title: "Edit Client",
      submitLabel: "Save",
      initial: client,
      onSubmit: (updated) {
        context.read<ClientBloc>().add(
          UpdateClientSubmitted(id: client.id!, client: updated),
        );
      },
    );
  }
}
