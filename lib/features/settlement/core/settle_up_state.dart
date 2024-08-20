part of 'settle_up_bloc.dart';

abstract class SettleUpState extends Equatable {
  const SettleUpState();
  @override
  List<Object> get props => [];
}

final class SettleUpInitial extends SettleUpState {}

final class SettleUpLoading extends SettleUpState {}

final class SettleUpLoaded extends SettleUpState {
  final List<Balance> balances;

  const SettleUpLoaded(this.balances);
  @override
  List<Object> get props => [balances];
}

final class SettleUpSuccess extends SettleUpState {}

final class SettleUpFailure extends SettleUpState {
  final String error;

  SettleUpFailure({required this.error});

  @override
  List<Object> get props => [error];
}
