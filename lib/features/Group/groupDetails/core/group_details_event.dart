part of 'group_details_bloc.dart';

abstract class GroupDetailsEvent extends Equatable {
  const GroupDetailsEvent();
  @override
  List<Object> get props => [];
}


// class GetExpense extends GroupDetailsEvent{
//   final int groupId;
//
//   const GetExpense(this.groupId);
//
//   @override
//   List<Object> get props => [groupId];
// }
//
// class GetBalance extends GroupDetailsEvent{
//   final int groupId;
//
//   const GetBalance(this.groupId);
//
//   @override
//   List<Object> get props => [groupId];
// }

class FetchGroupDetails extends GroupDetailsEvent{
  final int groupId;

  const FetchGroupDetails(this.groupId);

  @override
  List<Object> get props => [groupId];
}