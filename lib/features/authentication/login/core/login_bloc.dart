// import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../data/api/auth.dart';



part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
 final apiClient = ApiClient1();
  LoginBloc() : super(LoginInitial()) {
    on<LoginRequested>((event, emit) async {
      // TODO: implement event handler
      emit(LoginLoading());
      try {
        final response = await apiClient.login(event.email, event.password);
        emit(LoginSuccess(userData: response));

      } catch (e) {
        emit(LoginFailure(error: e.toString()));
      }
    });
  }
}
