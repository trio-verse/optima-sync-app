import 'package:equatable/equatable.dart';

class CheckSelectedOrgState extends Equatable {
  const CheckSelectedOrgState();

  @override
  List<Object> get props => [];
}

final class CheckSelectedOrgInitial extends CheckSelectedOrgState {}

final class CheckSelectedOrgLoading extends CheckSelectedOrgState {}

final class CheckSelectedOrgSuccess extends CheckSelectedOrgState {
  final bool hasSelected;

  const CheckSelectedOrgSuccess({required this.hasSelected});

  @override
  List<Object> get props => [hasSelected];
}
