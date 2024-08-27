import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/api/repository.dart';

part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final repo = Repository();

  LogoutBloc() : super(LogoutInitial()) {
    on<LogoutRequested>((event, emit) async {
      // TODO: implement event handler
      emit(LogoutLoading());
      try {
        await repo.logout();
        emit(LogoutSuccess());
      } catch (e) {
        emit(LogoutFailure(error: e.toString()));
      }
    });
  }
}
