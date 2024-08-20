import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/api/auth.dart';

part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final apiClient = ApiClient1();

  LogoutBloc() : super(LogoutInitial()) {
    on<LogoutRequested>((event, emit) async {
      // TODO: implement event handler
      emit(LogoutLoading());
      try {
        await apiClient.logout();
        emit(LogoutSuccess());
      } catch (e) {
        emit(LogoutFailure(error: e.toString()));
      }
    });
  }
}
