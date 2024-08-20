part of 'settle_up_dialog_bloc.dart';

abstract class SettleUpDialogState extends Equatable {
  const SettleUpDialogState();
  @override
  List<Object> get props => [];
}

final class SettleUpDialogInitial extends SettleUpDialogState {}

final class SettleUpDialogLoading extends SettleUpDialogState {}

final class SettleUpDialogSuccess extends SettleUpDialogState {}

final class SettleUpDialogFailure extends SettleUpDialogState {
  final String error;

  SettleUpDialogFailure({required this.error});

  @override
  List<Object> get props => [error];
}