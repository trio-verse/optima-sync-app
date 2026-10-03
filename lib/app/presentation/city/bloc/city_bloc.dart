import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/city_entity.dart';
import 'package:optima_sync_v2/app/domain/usecases/city_usecases.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

import 'city_event.dart';
import 'city_state.dart';

class CityBloc extends Bloc<CityEvent, CityState> {
  final CityUsecases usecases;

  CityBloc({required this.usecases}) : super(CityInitial()) {
    on<LoadCities>(_onLoadCities);
    on<AddCitySubmitted>(_onAddCitySubmitted);
    on<UpdateCitySubmitted>(_onUpdateCitySubmitted);
    on<DeleteCitySubmitted>(_onDeleteCitySubmitted);
  }

  Future<void> _onLoadCities(LoadCities event, Emitter<CityState> emit) async {
    emit(CityLoading());

    try {
      final result = await usecases.getCities();

      result.fold(
        (l) => emit(CityFailure(message: _messageFor(l))),
        (r) => emit(CitySuccess(cities: r)),
      );
    } catch (e) {
      emit(CityFailure(message: e.toString()));
    }
  }

  Future<void> _onAddCitySubmitted(
    AddCitySubmitted event,
    Emitter<CityState> emit,
  ) async {
    final currentState = state;
    final existingCities = currentState is CitySuccess
        ? currentState.cities
        : const <CityEntity>[];

    emit(CityLoading());

    try {
      final name = event.name.trim();

      if (name.isEmpty) {
        emit(
          CityFailure(
            message: 'City name cannot be empty',
            cities: existingCities,
          ),
        );
        return;
      }

      final createResult = await usecases.createCity(
        name: name,
        color: event.color,
      );

      final createFailure = createResult.fold((l) => l, (r) => null);

      if (createFailure != null) {
        emit(
          CityFailure(
            message: _messageFor(createFailure),
            cities: existingCities,
          ),
        );
        return;
      }

      final citiesResult = await usecases.getCities();

      citiesResult.fold(
        (l) => emit(
          CityFailure(message: _messageFor(l), cities: existingCities),
        ),
        (r) => emit(CitySuccess(cities: r)),
      );
    } catch (e) {
      emit(CityFailure(message: e.toString(), cities: existingCities));
    }
  }

  Future<void> _onUpdateCitySubmitted(
    UpdateCitySubmitted event,
    Emitter<CityState> emit,
  ) async {
    final currentState = state;
    final existingCities = currentState is CitySuccess
        ? currentState.cities
        : const <CityEntity>[];

    emit(CityLoading());

    try {
      final name = event.name.trim();

      if (name.isEmpty) {
        emit(
          CityFailure(
            message: 'City name cannot be empty',
            cities: existingCities,
          ),
        );
        return;
      }

      final updateResult = await usecases.updateCity(
        id: event.id,
        name: name,
        color: event.color,
      );

      final updateFailure = updateResult.fold((l) => l, (r) => null);

      if (updateFailure != null) {
        emit(
          CityFailure(
            message: _messageFor(updateFailure),
            cities: existingCities,
          ),
        );
        return;
      }

      final citiesResult = await usecases.getCities();

      citiesResult.fold(
        (l) => emit(
          CityFailure(message: _messageFor(l), cities: existingCities),
        ),
        (r) => emit(CitySuccess(cities: r)),
      );
    } catch (e) {
      emit(CityFailure(message: e.toString(), cities: existingCities));
    }
  }

  Future<void> _onDeleteCitySubmitted(
    DeleteCitySubmitted event,
    Emitter<CityState> emit,
  ) async {
    final currentState = state;

    if (currentState is! CitySuccess) {
      return;
    }

    final existingCities = currentState.cities;

    emit(CityLoading());

    try {
      final deleteResult = await usecases.deleteCity(event.id);

      final deleteFailure = deleteResult.fold((l) => l, (r) => null);

      if (deleteFailure != null) {
        emit(
          CityFailure(
            message: _messageFor(deleteFailure),
            cities: existingCities,
          ),
        );
        return;
      }

      final updatedCities = existingCities
          .where((city) => city.id != event.id)
          .toList();

      emit(CitySuccess(cities: updatedCities));
    } catch (e) {
      emit(CityFailure(message: e.toString(), cities: existingCities));
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
