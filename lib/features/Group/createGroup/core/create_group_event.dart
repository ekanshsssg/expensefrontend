part of 'create_group_bloc.dart';

abstract class CreateGroupEvent extends Equatable {
  const CreateGroupEvent();

  @override
  List<Object> get props => [];
}

class CreateGroupRequested extends CreateGroupEvent {
  // final Group group;
final String name;
final String description;
  const CreateGroupRequested({required this.name,required this.description});

  @override
  List<Object> get props => [name,description];
}
