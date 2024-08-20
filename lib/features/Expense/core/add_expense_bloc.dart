import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/api/auth.dart';
import '../../../data/api/secure_storage.dart';
import '../../../data/models/member.dart';

part 'add_expense_event.dart';
part 'add_expense_state.dart';

class AddExpenseBloc extends Bloc<AddExpenseEvent, AddExpenseState> {
  final apiClient = ApiClient1();
  final _secureStorage = SecureStorage();
  AddExpenseBloc() : super(AddExpenseInitial()) {
    on<FetchGroupMembers>((event, emit) async {
      emit(AddExpenseLoading());
      try {
        final members = await apiClient.fetchGroupMembers(event.groupId);
        // print(members);
        emit(AddExpenseMembersLoaded(members));
        // print(members);
      } catch (err) {
        emit(AddExpenseFailure(error:err.toString()));
      }
    });
    on<AddExpense>((event, emit) async{
      // TODO: implement event handler
      emit(AddExpenseLoading());
      try{
        final response = await apiClient.addExpense(event.category,event.groupId,event.paidBy,event.members,event.description,event.amount);
        emit(AddExpenseSuccess());
      }catch(err){
        emit(AddExpenseFailure(error:err.toString()));
      }
    });
  }
}
