import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/api/auth.dart';
import '../../../../data/api/secure_storage.dart';
import '../../../../data/models/balance.dart';
import '../../../../data/models/expense.dart';

part 'group_details_event.dart';
part 'group_details_state.dart';

class GroupDetailsBloc extends Bloc<GroupDetailsEvent, GroupDetailsState> {
  final apiClient = ApiClient1();
  GroupDetailsBloc() : super(GroupDetailsInitial()) {
    on<FetchGroupDetails>((event, emit) async {
      // TODO: implement event handler
      emit(GroupDetailsLoading());
      try {
        final results = await Future.wait([apiClient.getExpense(event.groupId),apiClient.getBalances(event.groupId)]);
        // final expenses = await apiClient.getExpense(event.groupId);
        // final balances = await apiClient.getBalances(event.groupId);

        // print(expenses);

        final expenses = results[0] as List<Expense>;
        final balances = results[1] as List<Balance>;
        print(balances);
        emit(GroupDetailsLoaded(expenses,balances));
        // print("hi11");

      } catch (e) {
        emit(GroupDetailsFailure(e.toString()));
      }
    });
  }
}
