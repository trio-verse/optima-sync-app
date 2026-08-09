import 'package:equatable/equatable.dart';
import 'navigation_state.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}

class ChangeTab extends NavigationEvent {
  final NavigationTab currentTab;

  const ChangeTab({required this.currentTab});

  @override
  List<Object> get props => [currentTab];
}
