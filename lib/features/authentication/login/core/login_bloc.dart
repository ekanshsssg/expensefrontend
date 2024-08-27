// import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../data/api/repository.dart';



part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
 final repo = Repository();
  LoginBloc() : super(LoginInitial()) {
    on<LoginRequested>((event, emit) async {
      // TODO: implement event handler
      emit(LoginLoading());
      try {
        final response = await repo.login(event.email, event.password);
        emit(LoginSuccess(userData: response));

      } catch (e) {
        emit(LoginFailure(error: e.toString()));
      }
    });
  }
}
