import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/usecases/org_usecases.dart';

import 'org_event.dart';
import 'org_state.dart';

class CreateOrgBloc extends Bloc<CreateOrgEvent, CreateOrgState> {
  final OrgUsecases usecases;

  CreateOrgBloc({required this.usecases}) : super(CreateOrgInitial()) {
    on<CreateOrgSubmitted>(_createOrganization);
  }

  Future<void> _createOrganization(
    CreateOrgSubmitted event,
    Emitter<CreateOrgState> emit,
  ) async {
    emit(CreateOrgLoading());

    try {
      if (event.org.id == null) {
        final organizationId = await usecases.createOrg(event.org);

        await usecases.saveSelectedOrganization(organizationId);

        emit(CreateOrgSuccess(organizationId: organizationId));
      } else {
        await usecases.updateOrg(event.org);

        emit(CreateOrgSuccess(organizationId: event.org.id!));
      }
    } catch (e) {
      emit(CreateOrgFailure(message: e.toString()));
    }
  }
}
