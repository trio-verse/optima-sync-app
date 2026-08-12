import 'package:bloc/bloc.dart';
import 'package:optima_sync_v2/app/domain/usecases/org_usecases.dart';
import 'package:optima_sync_v2/app/presentation/Org/blocs/check_selected_org/cubit/check_selected_org_state.dart';

class CheckSelectedOrgCubit extends Cubit<CheckSelectedOrgState> {
  final OrgUsecases usecases;
  CheckSelectedOrgCubit({required this.usecases})
    : super(CheckSelectedOrgInitial());

  Future<void> hasSelectedOrganization() async {
    emit(CheckSelectedOrgLoading());

    try {
      final hasSelected = await usecases.CheckSelectedOrg();

      emit(CheckSelectedOrgSuccess(hasSelected: hasSelected));
    } catch (e) {
      emit(CheckSelectedOrgInitial());
    }
  }
}
