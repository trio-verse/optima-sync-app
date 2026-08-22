import 'package:equatable/equatable.dart';
import 'home_state.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class ChangeTab extends HomeEvent {
  final HomeTab currentTab;

  const ChangeTab({required this.currentTab});

  @override
  List<Object> get props => [currentTab];
}
