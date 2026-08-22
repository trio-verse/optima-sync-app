import 'package:equatable/equatable.dart';

abstract class CityEvent extends Equatable {
  const CityEvent();

  @override
  List<Object?> get props => [];
}

class LoadCities extends CityEvent {}

class AddCitySubmitted extends CityEvent {
  final String name;
  final String color;

  const AddCitySubmitted({required this.name, required this.color});

  @override
  List<Object?> get props => [name, color];
}
