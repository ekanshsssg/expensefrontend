part of 'add_expense_bloc.dart';

abstract class AddExpenseState extends Equatable {
  const AddExpenseState();
  @override
  List<Object> get props => [];
}

class AddExpenseInitial extends AddExpenseState {}

class AddExpenseLoading extends AddExpenseState {}

class AddExpenseMembersLoaded extends AddExpenseState{
  final List<Member> members;

  const AddExpenseMembersLoaded(this.members);

  @override
  List<Object> get props=>[members];
}

class AddExpenseSuccess extends AddExpenseState {}

class AddExpenseFailure extends AddExpenseState {
  final String error;

  const AddExpenseFailure({required this.error});

  @override
  List<Object> get props => [error];
}