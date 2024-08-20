part of 'create_group_bloc.dart';

abstract class CreateGroupState extends Equatable {
  const CreateGroupState();

  @override
  List<Object> get props => [];
}

class CreateGroupInitial extends CreateGroupState {}

class CreateGroupLoading extends CreateGroupState {}

class CreateGroupSuccess extends CreateGroupState {}

class CreateGroupFailure extends CreateGroupState {
  final String error;

  const CreateGroupFailure({required this.error});

  @override
  List<Object> get props => [error];
}
