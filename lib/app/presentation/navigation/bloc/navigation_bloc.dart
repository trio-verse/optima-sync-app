import 'package:flutter_bloc/flutter_bloc.dart';

import 'navigation_event.dart';
import 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc()
    : super(const NavigationLoaded(currentTab: NavigationTab.dashboard)) {
    on<ChangeTab>(_onChangeTab);
  }

  void _onChangeTab(ChangeTab event, Emitter<NavigationState> emit) {
    emit(NavigationLoaded(currentTab: event.currentTab));
  }
}
