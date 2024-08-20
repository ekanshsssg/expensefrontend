part of 'add_expense_bloc.dart';

abstract class AddExpenseEvent extends Equatable {
  const AddExpenseEvent();
}

class FetchGroupMembers extends AddExpenseEvent{
  final int groupId;

  const FetchGroupMembers(this.groupId);

  @override
  List<Object> get props => [groupId];
}

class AddExpense extends AddExpenseEvent{
  final int groupId;
  final String category;
  final double amount;
  final String description;
  final int paidBy;
  final List<int> members;

  const AddExpense({required this.groupId,required this.category,required this.amount,required this.description,required this.paidBy,required this.members});
  @override
  List<Object> get props => [groupId,category,amount,description,paidBy,members];
}