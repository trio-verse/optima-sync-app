import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/usecases/org_usecases.dart';

import 'select_organization_event.dart';
import 'select_organization_state.dart';

class SelectOrganizationBloc
    extends Bloc<SelectOrganizationEvent, SelectOrganizationState> {
  final OrgUsecases usecases;

  SelectOrganizationBloc({required this.usecases})
    : super(SelectOrganizationInitial()) {
    on<SelectOrganizationSubmitted>(_selectOrganization);
    on<LoadOrganizations>(_loadOrganizations);
  }

  Future<void> _selectOrganization(
    SelectOrganizationSubmitted event,
    Emitter<SelectOrganizationState> emit,
  ) async {
    emit(SelectOrganizationLoading());

    try {
      // await usecases.selectOrganization(organizationId: event.organizationId);
      await usecases.saveSelectedOrganization(event.organizationId);

      emit(SelectOrganizationSelected(organizationId: event.organizationId));
    } catch (e) {
      emit(SelectOrganizationFailure(message: e.toString()));
    }
  }

  Future<void> _loadOrganizations(
    LoadOrganizations event,
    Emitter<SelectOrganizationState> emit,
  ) async {
    emit(SelectOrganizationLoading());

    try {
      final organizations = await usecases.getOrganizations();
      final selectedId = await usecases.getSelectedOrganizationId();
      print(organizations.where((t) => t.id == selectedId));
      print(selectedId);
      emit(
        SelectOrganizationSuccess(
          organizations: organizations,
          selectedId: selectedId,
        ),
      );
    } catch (e) {
      emit(SelectOrganizationFailure(message: e.toString()));
    }
  }
}
