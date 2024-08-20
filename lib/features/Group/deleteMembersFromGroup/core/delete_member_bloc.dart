import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expensefrontend/data/api/auth.dart';

import '../../../../data/models/member.dart';
import '../../../../data/api/secure_storage.dart';

part 'delete_member_event.dart';
part 'delete_member_state.dart';

class DeleteMembersBloc extends Bloc<DeleteMemberEvent, DeleteMembersState> {
  final apiClient = ApiClient1();
  final _secureStorage = SecureStorage();
  DeleteMembersBloc() : super(DeleteMembersInitial()) {
    on<FetchGroupMembers>((event, emit) async {
      emit(DeleteMembersLoading());
      try {
        final members = await apiClient.fetchGroupMembers(event.groupId);
        print(members);
        emit(DeleteMembersLoaded(members: members));
      } catch (err) {
        emit(DeleteMembersFailure(err.toString()));
      }
    });

    on<DeleteSelectedMembers>((event, emit) async {
      emit(DeleteMembersLoading());
      try {
        final userIdStr = await _secureStorage.readSecureData('userId');
        final userId = int.parse(userIdStr);
        final response = await apiClient.deleteSelectedMembers(
            event.groupId, event.selectedMembers,userId);
        emit(DeleteMembersSuccess(message: response));
      } catch (err) {
        emit(DeleteMembersFailure(err.toString()));
      }
    });
  }
}
