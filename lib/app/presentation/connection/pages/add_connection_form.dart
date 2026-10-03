import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/presentation/connection/bloc/connection_bloc.dart';
import 'package:optima_sync_v2/app/presentation/connection/bloc/connection_event.dart';

import 'connection_form.dart';

class AddConnectionForm extends StatelessWidget {
  final String clientId;

  const AddConnectionForm({super.key, required this.clientId});

  @override
  Widget build(BuildContext context) {
    return ConnectionForm(
      title: "New Connection",
      submitLabel: "Add",
      onSubmit: (connection) {
        context.read<ConnectionBloc>().add(
          AddConnectionSubmitted(clientId: clientId, connection: connection),
        );
      },
    );
  }
}
