import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/member_entity.dart';
import 'package:optima_sync_v2/app/domain/usecases/member_usecases.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

import 'member_event.dart';
import 'member_state.dart';

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  final MemberUsecases usecases;

  MemberBloc({required this.usecases}) : super(MemberInitial()) {
    on<LoadMembers>(_onLoadMembers);
    on<AddMemberSubmitted>(_onAddMemberSubmitted);
    on<UpdateMemberRoleSubmitted>(_onUpdateMemberRoleSubmitted);
  }

  List<MemberEntity> _getCurrentMembers() {
    final currentState = state;

    if (currentState is MemberSuccess) return currentState.members;
    if (currentState is MemberSubmitting) return currentState.members;
    if (currentState is MemberFailure) return currentState.members ?? const [];

    return const [];
  }

  Future<void> _onLoadMembers(
    LoadMembers event,
    Emitter<MemberState> emit,
  ) async {
    emit(MemberLoading());

    final result = await usecases.getMembers();

    result.fold(
      (failure) => emit(MemberFailure(message: _messageFor(failure))),
      (members) => emit(MemberSuccess(members: members)),
    );
  }

  Future<void> _onAddMemberSubmitted(
    AddMemberSubmitted event,
    Emitter<MemberState> emit,
  ) async {
    final existingMembers = _getCurrentMembers();
    final email = event.email.trim();

    if (email.isEmpty) {
      emit(
        MemberFailure(
          message: 'Email address cannot be empty',
          members: existingMembers,
        ),
      );
      return;
    }

    final isDuplicate = existingMembers.any(
      (member) => member.email?.toLowerCase() == email.toLowerCase(),
    );

    if (isDuplicate) {
      emit(
        MemberFailure(
          message: 'This member has already been added',
          members: existingMembers,
        ),
      );
      return;
    }

    emit(MemberSubmitting(members: existingMembers));

    final result = await usecases.addMember(email: email, role: event.role);

    result.fold(
      (failure) => emit(
        MemberFailure(message: _messageFor(failure), members: existingMembers),
      ),
      (newMember) =>
          emit(MemberSuccess(members: [newMember, ...existingMembers])),
    );
  }

  Future<void> _onUpdateMemberRoleSubmitted(
    UpdateMemberRoleSubmitted event,
    Emitter<MemberState> emit,
  ) async {
    final existingMembers = _getCurrentMembers();

    emit(
      MemberSubmitting(
        members: existingMembers,
        updatingId: event.memberId,
      ),
    );

    final result = await usecases.updateMemberRole(
      memberId: event.memberId,
      role: event.role,
    );

    result.fold(
      (failure) => emit(
        MemberFailure(message: _messageFor(failure), members: existingMembers),
      ),
      (_) {
        final updatedMembers = existingMembers.map((member) {
          if (member.id == event.memberId) {
            return member.copyWith(role: event.role);
          }
          return member;
        }).toList();

        emit(MemberSuccess(members: updatedMembers));
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
