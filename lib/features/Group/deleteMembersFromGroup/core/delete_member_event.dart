part of 'delete_member_bloc.dart';

abstract class DeleteMemberEvent extends Equatable {
  const DeleteMemberEvent();

  @override
  List<Object> get props => [];
}

class FetchGroupMembers extends DeleteMemberEvent{
  final int groupId;

  const FetchGroupMembers(this.groupId);

  @override
  List<Object> get props => [groupId];
}


class DeleteSelectedMembers extends DeleteMemberEvent{
  final int groupId;
  final List<int> selectedMembers;

  const DeleteSelectedMembers({required this.groupId,required this.selectedMembers});

  @override
  List<Object> get props => [groupId,selectedMembers];
}