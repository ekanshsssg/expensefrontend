part of 'delete_member_bloc.dart';

abstract class DeleteMembersState extends Equatable {
  const DeleteMembersState();
  @override
  List<Object> get props => [];
}

class DeleteMembersInitial extends DeleteMembersState {}

class DeleteMembersLoading extends DeleteMembersState{}

class DeleteMembersLoaded extends DeleteMembersState{
  final List<Member> members;

  const DeleteMembersLoaded({required this.members});

  @override
  List<Object> get props => [members];
}


class DeleteMembersSuccess extends DeleteMembersState{
  final String message;

  const DeleteMembersSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class DeleteMembersFailure extends DeleteMembersState{
  final String error;

  const DeleteMembersFailure(this.error);
  @override
  List<Object> get props => [error];
}
