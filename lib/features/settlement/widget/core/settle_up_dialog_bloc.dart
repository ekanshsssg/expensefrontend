import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expensefrontend/data/api/auth.dart';

part 'settle_up_dialog_event.dart';
part 'settle_up_dialog_state.dart';

class SettleUpDialogBloc extends Bloc<SettleUpDialogEvent, SettleUpDialogState> {
  final apiClient = ApiClient1();
  SettleUpDialogBloc() : super(SettleUpDialogInitial()) {
    on<SettleUp>((event,emit) async{
      try{
        emit(SettleUpDialogLoading());
        await apiClient.addSettlement(event.groupId,event.amount,event.settleWith,event.str);
        emit(SettleUpDialogSuccess());
      }catch(e){
        emit(SettleUpDialogFailure(error: e.toString()));
      }

    });
  }
}
