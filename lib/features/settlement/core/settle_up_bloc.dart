import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/api/repository.dart';
import '../../../data/models/balance.dart';


part 'settle_up_event.dart';
part 'settle_up_state.dart';

class SettleUpBloc extends Bloc<SettleUpEvent, SettleUpState> {
  final repo = Repository(
  );

  SettleUpBloc() : super(SettleUpInitial()) {
    on<FetchBalances>((event, emit) async {
      emit(SettleUpLoading());
      try {
        final balances = await repo.getBalances(event.groupId);
        emit(SettleUpLoaded(balances));
      } catch (e) {
        emit(SettleUpFailure(error: e.toString()));
      }
    });


  }
}
