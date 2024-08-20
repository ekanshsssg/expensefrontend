import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/api/auth.dart';
import '../../../data/models/activity.dart';

part 'activity_event.dart';
part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final apiClient = ApiClient1();
  ActivityBloc() : super(ActivityInitial()) {
    on<GetActivityEvent>((event, emit) async{
      // TODO: implement event handler
      try{
        emit(ActivityLoading());
        final response = await apiClient.getActivity();
        emit(ActivityLoaded(response));
      } catch (e){
        emit(ActivityLoadFailure());
      }
    });
  }
}
