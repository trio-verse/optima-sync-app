import 'package:equatable/equatable.dart';
import 'package:optima_sync_v2/app/domain/entities/city_entity.dart';

abstract class CityState extends Equatable {
  const CityState();

  @override
  List<Object?> get props => [];
}

class CityInitial extends CityState {}

class CityLoading extends CityState {}

class CitySuccess extends CityState {
  final List<CityEntity> cities;

  const CitySuccess({required this.cities});

  @override
  List<Object?> get props => [cities];
}

class CityFailure extends CityState {
  final String message;
  final List<CityEntity>? cities;

  const CityFailure({required this.message, this.cities});

  @override
  List<Object?> get props => [message, cities];
}

class CityUpdating extends CityState {
  final List<CityEntity> cities;
  final String cityId;

  const CityUpdating({required this.cities, required this.cityId});

  @override
  List<Object?> get props => [cities, cityId];
}
