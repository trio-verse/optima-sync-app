import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/usecases/org_usecases.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

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

    final orgsResult = await usecases.getOrganizations();

    await orgsResult.fold(
      (failure) async =>
          emit(SelectOrganizationFailure(message: _messageFor(failure))),
      (organizations) async {
        final selectedId = await usecases.getSelectedOrganizationId();
        emit(
          SelectOrganizationSuccess(
            organizations: organizations,
            selectedId: selectedId,
          ),
        );
      },
    );
  }

  String _messageFor(WhateverFailure failure) {
    return failure.when(
      serverError: () => 'Server error, please try again',
      whatoffline: () => 'No internet connection',
      database: () => 'Something went wrong, please try again',
    );
  }
}
