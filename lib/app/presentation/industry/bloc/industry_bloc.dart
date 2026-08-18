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

  List<IndustryEntity> _currentIndustries(IndustryState state) {
    if (state is IndustrySuccess) return state.industries;
    if (state is IndustryAdding) return state.industries;
    if (state is IndustryAddFailure) return state.industries;
    return [];
  }
}
