// part of 'group_bloc.dart';
//
// abstract class GroupsEvent extends Equatable {
//   const GroupsEvent();
//
//   @override
//   List<Object> get props => [];
// }
//
// class LoadGroupsEvent extends GroupsEvent {}
//
// class AddGroupEvent extends GroupsEvent {
//   final String groupName;
//   final List<String> members;
//
//   const AddGroupEvent({required this.groupName, required this.members});
//
//   @override
//   List<Object> get props => [groupName, members];
// }


part of 'group_bloc.dart';

abstract class GroupEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchGroupsEvent extends GroupEvent {}


