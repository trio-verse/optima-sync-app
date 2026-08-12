import 'package:equatable/equatable.dart';

enum NavigationTab { dashboard, industries, marketing, sales, settings }

abstract class NavigationState extends Equatable {
  const NavigationState();

  @override
  List<Object> get props => [];
}

class NavigationLoaded extends NavigationState {
  final NavigationTab currentTab;

  const NavigationLoaded({required this.currentTab});

  @override
  List<Object> get props => [currentTab];
}
