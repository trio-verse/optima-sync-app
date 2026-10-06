import 'package:equatable/equatable.dart';
import 'package:optima_sync_v2/app/domain/entities/member_entity.dart';

abstract class MemberState extends Equatable {
  const MemberState();

  @override
  List<Object?> get props => [];
}

class MemberInitial extends MemberState {}

class MemberLoading extends MemberState {}

class MemberSuccess extends MemberState {
  final List<MemberEntity> members;

  const MemberSuccess({required this.members});

  @override
  List<Object?> get props => [members];
}

class MemberSubmitting extends MemberState {
  final List<MemberEntity> members;
  final String? updatingId;

  const MemberSubmitting({required this.members, this.updatingId});

  @override
  List<Object?> get props => [members, updatingId];
}

class MemberFailure extends MemberState {
  final String message;
  final List<MemberEntity>? members;

  const MemberFailure({required this.message, this.members});

  @override
  List<Object?> get props => [message, members];
}
