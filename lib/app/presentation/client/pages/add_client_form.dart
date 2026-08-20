import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/presentation/client/bloc/client_bloc.dart';
import 'package:optima_sync_v2/app/presentation/client/bloc/client_event.dart';

import 'client_form.dart';

class AddClientForm extends StatelessWidget {
  const AddClientForm({super.key});

  @override
  Widget build(BuildContext context) {
    return ClientForm(
      title: "Add Client",
      submitLabel: "Add",
      onSubmit: (client) {
        context.read<ClientBloc>().add(AddClientSubmitted(client: client));
      },
    );
  }
}
