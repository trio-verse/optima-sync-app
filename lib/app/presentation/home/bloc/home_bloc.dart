import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeLoaded(currentTab: HomeTab.dashboard)) {
    on<ChangeTab>(_onChangeTab);
  }

  void _onChangeTab(ChangeTab event, Emitter<HomeState> emit) {
    emit(HomeLoaded(currentTab: event.currentTab));
  }
}
