import 'package:equatable/equatable.dart';

abstract class MemberEvent extends Equatable {
  const MemberEvent();

  @override
  List<Object?> get props => [];
}

class LoadMembers extends MemberEvent {}

class AddMemberSubmitted extends MemberEvent {
  final String email;
  final String role;

  const AddMemberSubmitted({required this.email, required this.role});

  @override
  List<Object?> get props => [email, role];
}

class UpdateMemberRoleSubmitted extends MemberEvent {
  final String memberId;
  final String role;

  const UpdateMemberRoleSubmitted({
    required this.memberId,
    required this.role,
  });

  @override
  List<Object?> get props => [memberId, role];
}
