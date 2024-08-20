import 'package:expensefrontend/data/api/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final apiClient = ApiClient1();
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterRequested>((event, emit) async{
      // TODO: implement event handler
      emit(RegisterLoading());
      try {
        final response = await apiClient.register(event.name, event.email, event.password);
        emit(RegisterSuccess(userData: response));

      } catch (e) {
        emit(RegisterFailure(error: e.toString()));
      }
    });
  }
}
