import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/industry_entity.dart';
import 'package:optima_sync_v2/app/domain/usecases/industry_usecases.dart';

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

    try {
      final industries = await usecases.getIndustries();

      emit(IndustrySuccess(industries: industries));
    } catch (e) {
      emit(IndustryFailure(message: e.toString()));
    }
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

    try {
      final created = await usecases.createIndustry(newName, event.newColor);

      final updatedIndustries = [created, ...currentIndustries];

      emit(IndustrySuccess(industries: updatedIndustries));
    } catch (e) {
      emit(
        IndustryAddFailure(
          industries: currentIndustries,
          message: e.toString(),
        ),
      );
    }
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

    try {
      final updatedIndustry = await usecases.updateIndustry(
        id: industryId,
        name: name,
        color: color,
      );

      final updatedIndustries = currentIndustries.map((industry) {
        if (industry.id == event.id) {
          return updatedIndustry;
        }

        return industry;
      }).toList();

      emit(IndustrySuccess(industries: updatedIndustries));
    } catch (e) {
      emit(IndustryFailure(message: e.toString()));
    }
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

    try {
      await usecases.deleteIndustry(id: industryId);

      final updatedIndustries = currentIndustries
          .where((industry) => industry.id != event.id)
          .toList();

      emit(IndustrySuccess(industries: updatedIndustries));
    } catch (e) {
      emit(IndustryFailure(message: e.toString()));
    }
  }

  List<IndustryEntity> _currentIndustries(IndustryState state) {
    if (state is IndustrySuccess) {
      return state.industries;
    }

    if (state is IndustryAdding) {
      return state.industries;
    }

    if (state is IndustryAddFailure) {
      return state.industries;
    }

    if (state is IndustryUpdating) {
      return state.industries;
    }
    if (state is IndustryDeleting) {
      return state.industries;
    }
    return [];
  }
}
