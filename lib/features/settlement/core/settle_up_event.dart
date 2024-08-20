part of 'settle_up_bloc.dart';

abstract class SettleUpEvent extends Equatable {
  const SettleUpEvent();
  @override
  List<Object> get props => [];
}

class FetchBalances extends SettleUpEvent{
  final int groupId;

  const FetchBalances(this.groupId);
  @override
  List<Object> get props => [groupId];
}

// class SettleUp extends SettleUpEvent{
//   final int groupId;
//   final double amount;
//   final int settleWith;
//   final String str;
//   const SettleUp({required this.groupId, required this.amount, required this.settleWith, required this.str});
//   @override
//   List<Object> get props => [groupId,amount];
// }