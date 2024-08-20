import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/api/auth.dart';
import '../../../data/models/balance.dart';

part 'settle_up_event.dart';
part 'settle_up_state.dart';

class SettleUpBloc extends Bloc<SettleUpEvent, SettleUpState> {
  final apiClient = ApiClient1();

  SettleUpBloc() : super(SettleUpInitial()) {
    on<FetchBalances>((event, emit) async {
      emit(SettleUpLoading());
      try {
        final balances = await apiClient.getBalances(event.groupId);
        emit(SettleUpLoaded(balances));
      } catch (e) {
        emit(SettleUpFailure(error: e.toString()));
      }
    });


  }
}
