import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/industry_entity.dart';
import 'package:optima_sync_v2/app/domain/usecases/industry_usecases.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

import 'industry_event.dart';
import 'industry_state.dart';

class IndustryBloc extends Bloc<IndustryEvent, IndustryState> {
  final IndustryUsecases usecases;

  IndustryBloc({required this.usecases}) : super(IndustryInitial()) {
    on<LoadIndustries>(_onLoadIndustries);
    on<AddIndustrySubmitted>(_onAddIndustrySubmitted);
    on<UpdateIndustrySubmitted>(_onUpdateIndustrySubmitted);
    on<DeleteIndustrySubmitted>(_onDeleteIndustrySubmitted);
  }

  Future<void> _onLoadIndustries(
    LoadIndustries event,
    Emitter<IndustryState> emit,
  ) async {
    emit(IndustryLoading());

    final result = await usecases.getIndustries();

    result.fold(
      (failure) => emit(IndustryFailure(message: _messageFor(failure))),
      (industries) => emit(IndustrySuccess(industries: industries)),
    );
  }

  Future<void> _onAddIndustrySubmitted(
    AddIndustrySubmitted event,
    Emitter<IndustryState> emit,
  ) async {
    final currentIndustries = _currentIndustries(state);

    final newName = event.newName.trim();

    if (newName.isEmpty) {
      emit(
        IndustryAddFailure(
          industries: currentIndustries,
          message: 'Industry name cannot be empty',
        ),
      );

      return;
    }

    emit(IndustryAdding(industries: currentIndustries));

    final result = await usecases.createIndustry(newName, event.newColor);

    result.fold(
      (failure) => emit(
        IndustryAddFailure(
          industries: currentIndustries,
          message: _messageFor(failure),
        ),
      ),
      (created) {
        final updatedIndustries = [created, ...currentIndustries];
        emit(IndustrySuccess(industries: updatedIndustries));
      },
    );
  }

  Future<void> _onUpdateIndustrySubmitted(
    UpdateIndustrySubmitted event,
    Emitter<IndustryState> emit,
  ) async {
    final currentIndustries = _currentIndustries(state);

    final name = event.name.trim();
    final color = event.color.trim();

    if (name.isEmpty) {
      emit(IndustryFailure(message: 'Industry name cannot be empty'));

      return;
    }

    final industryId = int.tryParse(event.id);

    if (industryId == null) {
      emit(IndustryFailure(message: 'Invalid industry ID'));

      return;
    }

    emit(IndustryUpdating(industries: currentIndustries, updatingId: event.id));

    final result = await usecases.updateIndustry(
      id: industryId,
      name: name,
      color: color,
    );

    result.fold(
      (failure) => emit(IndustryFailure(message: _messageFor(failure))),
      (updatedIndustry) {
        final updatedIndustries = currentIndustries.map((industry) {
          if (industry.id == event.id) {
            return updatedIndustry;
          }
          return industry;
        }).toList();

        emit(IndustrySuccess(industries: updatedIndustries));
      },
    );
  }

  Future<void> _onDeleteIndustrySubmitted(
    DeleteIndustrySubmitted event,
    Emitter<IndustryState> emit,
  ) async {
    final currentIndustries = _currentIndustries(state);

    final industryId = int.tryParse(event.id);

    if (industryId == null) {
      emit(IndustryFailure(message: 'Invalid industry ID'));
      return;
    }

    emit(IndustryDeleting(industries: currentIndustries, deletingId: event.id));

    final result = await usecases.deleteIndustry(id: industryId);

    result.fold(
      (failure) => emit(IndustryFailure(message: _messageFor(failure))),
      (_) {
        final updatedIndustries = currentIndustries
            .where((industry) => industry.id != event.id)
            .toList();

        emit(IndustrySuccess(industries: updatedIndustries));
      },
    );
  }

  List<IndustryEntity> _currentIndustries(IndustryState state) {
    if (state is IndustrySuccess) return state.industries;
    if (state is IndustryAdding) return state.industries;
    if (state is IndustryAddFailure) return state.industries;
    if (state is IndustryUpdating) return state.industries;
    if (state is IndustryDeleting) return state.industries;
    return [];
  }

  String _messageFor(WhateverFailure failure) {
    return failure.when(
      serverError: () => 'Server error, please try again',
      whatoffline: () => 'No internet connection',
      database: () => 'Something went wrong, please try again',
    );
  }
}
