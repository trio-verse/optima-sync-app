import 'package:equatable/equatable.dart';
import 'package:optima_sync_v2/app/domain/entities/org_entity.dart';

abstract class CreateAndUpdateOrgEvent extends Equatable {
  const CreateAndUpdateOrgEvent();

  @override
  List<Object> get props => [];
}

// class PickImageEvent extends CreateAndUpdateOrgEvent {}

class CreateAndUpdateOrgSubmitted extends CreateAndUpdateOrgEvent {
  final OrgEntity org;

  const CreateAndUpdateOrgSubmitted({required this.org});

  @override
  List<Object> get props => [org];
}
