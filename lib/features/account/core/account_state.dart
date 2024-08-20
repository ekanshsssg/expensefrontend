part of 'account_bloc.dart';

sealed class AccountState extends Equatable {
  const AccountState();
}

final class AccountInitial extends AccountState {
  @override
  List<Object> get props => [];
}
