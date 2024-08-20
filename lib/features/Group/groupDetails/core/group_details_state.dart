part of 'group_details_bloc.dart';

sealed class GroupDetailsState extends Equatable {
  const GroupDetailsState();
  @override
  List<Object> get props => [];
}

class GroupDetailsInitial extends GroupDetailsState {
}

class GroupDetailsLoading extends GroupDetailsState{}

class GroupDetailsLoaded extends GroupDetailsState{
 final List<Expense> expenses;
 final List<Balance> balances;

 const GroupDetailsLoaded(this.expenses,this.balances);
 @override
 List<Object> get props => [expenses,balances];
}


class GroupDetailsSuccess extends GroupDetailsState{}

class GroupDetailsFailure extends GroupDetailsState{
  final String error;

  const GroupDetailsFailure(this.error);
  @override
  List<Object> get props => [error];
}