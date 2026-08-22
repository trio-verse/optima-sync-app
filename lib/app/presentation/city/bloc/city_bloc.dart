import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/city_entity.dart';
import 'package:optima_sync_v2/app/domain/usecases/city_usecases.dart';

import 'city_event.dart';
import 'city_state.dart';

class CityBloc extends Bloc<CityEvent, CityState> {
  final CityUsecases usecases;

  CityBloc({required this.usecases}) : super(CityInitial()) {
    on<LoadCities>(_onLoadCities);
    on<AddCitySubmitted>(_onAddCitySubmitted);
  }

  Future<void> _onLoadCities(LoadCities event, Emitter<CityState> emit) async {
    emit(CityLoading());

    try {
      final cities = await usecases.getCities();

      emit(CitySuccess(cities: cities));
    } catch (e) {
      emit(CityFailure(message: e.toString()));
    }
  }

  Future<void> _onAddCitySubmitted(
    AddCitySubmitted event,
    Emitter<CityState> emit,
  ) async {
    final name = event.name.trim();
    final color = event.color.trim();

    if (name.isEmpty) {
      emit(const CityFailure(message: 'City name cannot be empty'));
      return;
    }

    if (color.isEmpty) {
      emit(const CityFailure(message: 'City color cannot be empty'));
      return;
    }

    final currentCities = state is CitySuccess
        ? (state as CitySuccess).cities
        : <CityEntity>[];

    emit(CityLoading());

    try {
      final newCity = await usecases.createCity(name: name, color: color);

      emit(CitySuccess(cities: [newCity, ...currentCities]));
    } catch (e) {
      emit(CityFailure(message: e.toString()));
    }
  }
}
