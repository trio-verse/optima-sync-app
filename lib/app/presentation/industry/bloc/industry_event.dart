import 'package:equatable/equatable.dart';

abstract class IndustryEvent extends Equatable {
  const IndustryEvent();

  @override
  List<Object?> get props => [];
}

class LoadIndustries extends IndustryEvent {}

class AddIndustrySubmitted extends IndustryEvent {
  final String newName;
  final String newColor;

  const AddIndustrySubmitted({required this.newName, required this.newColor});

  @override
  List<Object?> get props => [newName, newColor];
}

class UpdateIndustrySubmitted extends IndustryEvent {
  final String id;
  final String name;
  final String color;

  const UpdateIndustrySubmitted({
    required this.id,
    required this.name,
    required this.color,
  });

  @override
  List<Object?> get props => [id, name, color];
}

class DeleteIndustrySubmitted extends IndustryEvent {
  final String id;

  const DeleteIndustrySubmitted({required this.id});

  @override
  List<Object?> get props => [id];
}
