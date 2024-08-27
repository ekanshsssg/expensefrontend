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
