import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/usecases/org_usecases.dart';

import 'create_and_update_org_event.dart';
import 'create_and_update_org_state.dart';

class CreateAndUpdateOrgBloc
    extends Bloc<CreateAndUpdateOrgEvent, CreateAndUpdateOrgState> {
  final OrgUsecases usecases;

  CreateAndUpdateOrgBloc({required this.usecases})
    : super(CreateAndUpdateOrgInitial()) {
    on<CreateAndUpdateOrgSubmitted>(_CreateAndUpdateOrganization);
  }

  Future<void> _CreateAndUpdateOrganization(
    CreateAndUpdateOrgSubmitted event,
    Emitter<CreateAndUpdateOrgState> emit,
  ) async {
    emit(CreateAndUpdateOrgLoading());

    try {
      if (event.org.id == null) {
        final organizationId = await usecases.createOrg(event.org);

        await usecases.saveSelectedOrganization(organizationId);

        emit(CreateAndUpdateOrgSuccess(organizationId: organizationId));
      } else {
        await usecases.updateOrg(event.org);

        emit(CreateAndUpdateOrgSuccess(organizationId: event.org.id!));
      }
    } catch (e) {
      emit(CreateAndUpdateOrgFailure(message: e.toString()));
    }
  }
}
