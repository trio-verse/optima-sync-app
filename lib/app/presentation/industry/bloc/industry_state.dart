import 'package:equatable/equatable.dart';
import 'package:optima_sync_v2/app/domain/entities/industry_entity.dart';

abstract class IndustryState extends Equatable {
  const IndustryState();

  @override
  List<Object?> get props => [];
}

class IndustryInitial extends IndustryState {}

class IndustryLoading extends IndustryState {}

class IndustrySuccess extends IndustryState {
  final List<IndustryEntity> industries;

  const IndustrySuccess({required this.industries});

  @override
  List<Object?> get props => [industries];
}

class IndustryFailure extends IndustryState {
  final String message;

  const IndustryFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class IndustryAdding extends IndustryState {
  final List<IndustryEntity> industries;

  const IndustryAdding({required this.industries});

  @override
  List<Object?> get props => [industries];
}

class IndustryAddFailure extends IndustryState {
  final List<IndustryEntity> industries;
  final String message;

  const IndustryAddFailure({required this.industries, required this.message});

  @override
  List<Object?> get props => [industries, message];
}
