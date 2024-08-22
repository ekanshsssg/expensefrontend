part of 'add_members_bloc.dart';

abstract class AddMembersState extends Equatable {
  const AddMembersState();

  @override
  List<Object> get props => [];
}

class AddMembersInitial extends AddMembersState {}

class AddMembersLoading extends AddMembersState {}

class AddMembersLoaded extends AddMembersState {
  final List<Member> members;

  const AddMembersLoaded({required this.members});

  @override
  List<Object> get props => [members];
}

class YouAreAlreadyPresent extends AddMembersState{}

class YouAreAlreadySelected extends AddMembersState{}


class AddMembersSelected extends AddMembersState {
  final List<Member> selectedMembers;

  const AddMembersSelected({required this.selectedMembers});

  @override
  List<Object> get props => [selectedMembers];
}

class AddMembersSuccess extends AddMembersState {}

class AddMembersFailure extends AddMembersState {
  final String error;

  const AddMembersFailure({required this.error});

  @override
  List<Object> get props => [error];
}
