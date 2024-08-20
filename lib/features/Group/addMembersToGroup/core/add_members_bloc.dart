import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../data/api/auth.dart';
import '../../../../data/api/secure_storage.dart';
import '../../../../data/models/member.dart';

part 'add_members_event.dart';
part 'add_members_state.dart';

class AddMembersBloc extends Bloc<AddMembersEvent, AddMembersState> {
  final apiClient = ApiClient1();
  final _secureStorage = SecureStorage();
  final TextEditingController emailController = TextEditingController();
  List<Member> membersList = [];

  AddMembersBloc() : super(AddMembersInitial()) {
    on<SearchMembers>((event, emit) async {
      try {
        emit(AddMembersLoading());
        final member =
            await apiClient.searchMembersByEmail(event.email, event.groupId);
        final userIdStr = await _secureStorage.readSecureData('userId');
        final userId = int.parse(userIdStr);
        bool memberExists = membersList
            .any((existingMember) => existingMember.emailId == member!.emailId);
        // if (!memberExists && !(member.memberId == userId)) {
        //   membersList.add(member);
        // }
        if (!memberExists) {
          membersList.add(member!);
        }
        // if ((member.memberId == userId)) {
        //   emit(YouCanNotAddYourself());
        // }
        // print(membersList);
        if (memberExists) {
          emit(YouAreAlreadyPresent());
        }
        // await Future.delayed(const Duration(milliseconds: 250),(){});
        else emit(AddMembersSelected(selectedMembers: membersList));

        // print(members);
      } catch (e) {
        print(e);
        emit(AddMembersFailure(error: e.toString()));
      }
    });

    // on<AddMemberToSelection>((event, emit) {
    //   if (state is AddMembersLoaded) {
    //     final loadedState = state as AddMembersLoaded;
    //     print("h1");
    //     print(loadedState.members);
    //     emit(AddMembersSelected(
    //         // selectedMembers: [...loadedState.members, event.member]));
    //       selectedMembers: [event.member]));
    //
    //     } else if (state is AddMembersSelected) {
    //     final selectedState = state as AddMembersSelected;
    //     emit(AddMembersSelected(
    //         selectedMembers: [...selectedState.selectedMembers, event.member]));
    //   }
    // });

    on<RemoveMemberFromSelection>((event, emit) {
      if (state is AddMembersSelected) {
        // final selectedState = state as AddMembersSelected;
        membersList = membersList.where((m) => m != event.member).toList();
        emit(AddMembersSelected(selectedMembers: membersList));
      }
    });

    on<ConfirmAddMembers>((event, emit) async {
      final selectedState = state as AddMembersSelected;
      emit(AddMembersLoading());
      try {
        final userIdStr = await _secureStorage.readSecureData('userId');
        final userId = int.parse(userIdStr);
        debugPrint(selectedState.selectedMembers.toString());
        await apiClient.addMembersToGroup(
            event.groupId, selectedState.selectedMembers, userId);
        emit(AddMembersSuccess());
      } catch (e) {
        emit(AddMembersFailure(error: e.toString()));
      }
    });
  }
}
