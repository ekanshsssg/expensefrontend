part of 'add_members_bloc.dart';

abstract class AddMembersEvent extends Equatable {
  const AddMembersEvent();

  @override
  List<Object?> get props => [];
}

class SearchMembers extends AddMembersEvent {
  final String email;
  final int groupId;
  const SearchMembers(this.email,this.groupId);

  @override
  List<Object?> get props => [email];
}

// class AddMemberToSelection extends AddMembersEvent {
//   final Member member;
//
//   const AddMemberToSelection({required this.member});
//
//   @override
//   List<Object> get props => [member];
// }

class RemoveMemberFromSelection extends AddMembersEvent {
  final Member member;

  const RemoveMemberFromSelection({required this.member});

  @override
  List<Object> get props => [member];
}

class ConfirmAddMembers extends AddMembersEvent {
  final int groupId;

  const ConfirmAddMembers({required this.groupId});

  @override
  List<Object> get props => [groupId];
}