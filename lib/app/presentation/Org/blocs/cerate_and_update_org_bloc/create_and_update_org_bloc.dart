import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/usecases/org_usecases.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

import 'create_and_update_org_event.dart';
import 'create_and_update_org_state.dart';

class CreateAndUpdateOrgBloc
    extends Bloc<CreateAndUpdateOrgEvent, CreateAndUpdateOrgState> {
  final OrgUsecases usecases;

  CreateAndUpdateOrgBloc({required this.usecases})
      : super(CreateAndUpdateOrgInitial()) {
    on<CreateAndUpdateOrgSubmitted>(_createAndUpdateOrganization);
  }

  Future<void> _createAndUpdateOrganization(
    CreateAndUpdateOrgSubmitted event,
    Emitter<CreateAndUpdateOrgState> emit,
  ) async {
    emit(CreateAndUpdateOrgLoading());

    if (event.org.id == null) {
      final createResult = await usecases.createOrg(event.org);

      await createResult.fold(
        (failure) async =>
            emit(CreateAndUpdateOrgFailure(message: _messageFor(failure))),
        (organizationId) async {
          await usecases.saveSelectedOrganization(organizationId);
          emit(CreateAndUpdateOrgSuccess(organizationId: organizationId));
        },
      );
    } else {
      final updateResult = await usecases.updateOrg(event.org);

      updateResult.fold(
        (failure) => emit(CreateAndUpdateOrgFailure(message: _messageFor(failure))),
        (_) => emit(CreateAndUpdateOrgSuccess(organizationId: event.org.id!)),
      );
    }
  }

  String _messageFor(WhateverFailure failure) {
    return failure.when(
      serverError: () => 'Server error, please try again',
      whatoffline: () => 'No internet connection',
      database: () => 'Something went wrong, please try again',
    );
  }
}
