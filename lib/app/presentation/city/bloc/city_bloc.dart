import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/usecases/city_usecases.dart';

import 'city_event.dart';
import 'city_state.dart';

class CityBloc extends Bloc<CityEvent, CityState> {
  final CityUsecases usecases;

  CityBloc({required this.usecases}) : super(CityInitial()) {
    on<LoadCities>(_onLoadCities);
    on<AddCitySubmitted>(_onAddCitySubmitted);
    on<UpdateCitySubmitted>(_onUpdateCitySubmitted);
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
    emit(CityLoading());

    try {
      final name = event.name.trim();

      if (name.isEmpty) {
        emit(const CityFailure(message: 'City name cannot be empty'));
        return;
      }

      await usecases.createCity(name: name, color: event.color);

      final cities = await usecases.getCities();

      emit(CitySuccess(cities: cities));
    } catch (e) {
      emit(CityFailure(message: e.toString()));
    }
  }

  Future<void> _onUpdateCitySubmitted(
    UpdateCitySubmitted event,
    Emitter<CityState> emit,
  ) async {
    emit(CityLoading());

    try {
      final name = event.name.trim();

      if (name.isEmpty) {
        emit(const CityFailure(message: 'City name cannot be empty'));
        return;
      }

      await usecases.updateCity(id: event.id, name: name, color: event.color);

      final cities = await usecases.getCities();

      emit(CitySuccess(cities: cities));
    } catch (e) {
      emit(CityFailure(message: e.toString()));
    }
  }
}
