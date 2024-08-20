// import 'package:bloc/bloc.dart';
// import 'package:your_app/bloc/groups_event.dart';
// import 'package:your_app/bloc/groups_state.dart';
// import 'package:your_app/models/group.dart';
// import 'package:your_app/repository/group_repository.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:equatable/equatable.dart';
//
// part 'group_event.dart';
// part 'group_state.dart';
//
// class GroupsBloc extends Bloc<GroupsEvent, GroupsState> {
//   final GroupRepository groupRepository;`
//
//   GroupsBloc({required this.groupRepository}) : super(GroupsLoadInProgress()) {
//     on<LoadGroupsEvent>((event, emit) async {
//       emit(GroupsLoadInProgress());
//       try {
//         final groups = await groupRepository.getGroups();
//         emit(GroupsLoadSuccess(groups));
//       } catch (e) {
//         emit(GroupsLoadFailure(e.toString()));
//       }
//     });
//
//     on<AddGroupEvent>((event, emit) async {
//       try {
//         await groupRepository.addGroup(event.groupName, event.members);
//         final groups = await groupRepository.getGroups();
//         emit(GroupsLoadSuccess(groups));
//       } catch (e) {
//         emit(GroupsLoadFailure(e.toString()));
//       }
//     });
//   }
// }

import 'package:expensefrontend/data/api/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../data/models/groups_model.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final apiClient = ApiClient1();

  GroupBloc() : super(GroupInitialState()) {
    on<FetchGroupsEvent>((event, emit) async {
      emit(GroupLoadingState());
      try {
        final results = await Future.wait(
            [apiClient.fetchGroups(), apiClient.getOverallBalance()]);
        print(results);
        final groups = results[0] as List<Map<String, dynamic>>;
        print(groups);
        final overallBalance = results[1] as double;
        emit(GroupLoadedState(groups: groups, overallBalance: overallBalance));
      } catch (e) {
        print(e);
        emit(GroupErrorState(message: e.toString()));
      }
    });
  }
}
