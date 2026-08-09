import 'package:equatable/equatable.dart';
import 'package:optima_sync_v2/app/domain/entities/org_entity.dart';

abstract class CreateOrgEvent extends Equatable {
  const CreateOrgEvent();

  @override
  List<Object> get props => [];
}

// class PickImageEvent extends CreateOrgEvent {}

class CreateOrgSubmitted extends CreateOrgEvent {
  final OrgEntity org;

  const CreateOrgSubmitted({required this.org});

  @override
  List<Object> get props => [org];
}
