import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/connection_entity.dart';
import 'package:optima_sync_v2/app/presentation/connection/bloc/connection_bloc.dart';
import 'package:optima_sync_v2/app/presentation/connection/bloc/connection_event.dart';

import 'connection_form.dart';

class EditConnectionForm extends StatelessWidget {
  final String clientId;
  final ConnectionEntity connection;

  const EditConnectionForm({
    super.key,
    required this.clientId,
    required this.connection,
  });

  @override
  Widget build(BuildContext context) {
    return ConnectionForm(
      title: "Edit Connection",
      submitLabel: "Save",
      initial: connection,
      showStage: false,
      onSubmit: (updated) {
        context.read<ConnectionBloc>().add(
          UpdateConnectionSubmitted(
            id: connection.id!,
            clientId: clientId,
            connection: updated,
          ),
        );
      },
    );
  }
}
