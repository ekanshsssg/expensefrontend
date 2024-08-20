// part of 'group_bloc.dart';
// // import 'package:your_app/models/group.dart';
//
// abstract class GroupsState extends Equatable {
//   const GroupsState();
//
//   @override
//   List<Object> get props => [];
// }
//
// class GroupsLoadInProgress extends GroupsState {}
//
// class GroupsLoadSuccess extends GroupsState {
//   final List<Group> groups;
//
//   const GroupsLoadSuccess(this.groups);
//
//   @override
//   List<Object> get props => [groups];
// }
//
// class GroupsLoadFailure extends GroupsState {
//   final String error;
//
//   const GroupsLoadFailure(this.error);
//
//   @override
//   List<Object> get props => [error];
// }



part of 'group_bloc.dart';

abstract class GroupState extends Equatable {
  @override
  List<Object> get props => [];
}

class GroupInitialState extends GroupState {}

class GroupLoadingState extends GroupState {}

class GroupLoadedState extends GroupState {
  final List<Map<String,dynamic>> groups;
  final double overallBalance;

  GroupLoadedState({required this.groups,required this.overallBalance});

  @override
  List<Object> get props => [groups,overallBalance];
}

class GroupErrorState extends GroupState {
  final String message;

  GroupErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
