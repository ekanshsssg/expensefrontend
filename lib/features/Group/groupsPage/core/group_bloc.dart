import 'package:expensefrontend/data/api/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final repo = Repository(
  );

  GroupBloc() : super(GroupInitialState()) {
    on<FetchGroupsEvent>((event, emit) async {
      emit(GroupLoadingState());
      try {
        final results = await Future.wait(
            [repo.fetchGroups(), repo.getOverallBalance()]);
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
