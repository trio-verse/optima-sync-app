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
