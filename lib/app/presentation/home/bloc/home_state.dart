import 'package:equatable/equatable.dart';

enum HomeTab { dashboard, industries, marketing, sales, settings }

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeLoaded extends HomeState {
  final HomeTab currentTab;

  const HomeLoaded({required this.currentTab});

  @override
  List<Object> get props => [currentTab];
}
