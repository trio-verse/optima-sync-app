import 'package:equatable/equatable.dart';
import 'package:optima_sync_v2/app/domain/entities/sales_dashboard_entity.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeSuccess extends HomeState {
  final SalesDashboardEntity dashboard;

  const HomeSuccess({required this.dashboard});

  @override
  List<Object?> get props => [dashboard];
}

class HomeFailure extends HomeState {
  final String message;

  const HomeFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
