import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/api/repository.dart';
import '../../../../data/api/secure_storage.dart';
import '../../../../data/models/groups_model.dart';

part 'create_group_event.dart';
part 'create_group_state.dart';

class CreateGroupBloc extends Bloc<CreateGroupEvent, CreateGroupState> {
  final repo = Repository();
  final _secureStorage = SecureStorage();
  late final int userId;

  void _initialize() async {
    final userIdStr = await _secureStorage.readSecureData('userId');
    userId = int.parse(userIdStr);
  }

  CreateGroupBloc() : super(CreateGroupInitial()) {
    on<CreateGroupRequested>((event, emit) async {
      try {
        final response = await repo.createGroup(Group(name:event.name,description: event.description,created_by: userId,group_members: userId));
        emit(CreateGroupSuccess());
      } catch (e) {
        emit(CreateGroupFailure(error: e.toString()));
      }
    });
    _initialize();
  }
}
