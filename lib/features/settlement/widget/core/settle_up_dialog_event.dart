part of 'settle_up_dialog_bloc.dart';

abstract class SettleUpDialogEvent extends Equatable {
  const SettleUpDialogEvent();
  @override
  List<Object> get props => [];
}

class SettleUp extends SettleUpDialogEvent{
  final int groupId;
  final double amount;
  final int settleWith;
  final String str;
  const SettleUp({required this.groupId, required this.amount, required this.settleWith, required this.str});
  @override
  List<Object> get props => [groupId,amount,settleWith,str];
}