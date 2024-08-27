import 'package:expensefrontend/data/api/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final repo = Repository();
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterRequested>((event, emit) async{
      // TODO: implement event handler
      emit(RegisterLoading());
      try {
        final response = await repo.register(event.name, event.email, event.password);
        emit(RegisterSuccess(userData: response));

      } catch (e) {
        emit(RegisterFailure(error: e.toString()));
      }
    });
  }
}
