import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/api/repository.dart';
import '../../../data/models/activity.dart';

part 'activity_event.dart';
part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final repo = Repository();
  ActivityBloc() : super(ActivityInitial()) {
    on<GetActivityEvent>((event, emit) async{
      // TODO: implement event handler
      try{
        emit(ActivityLoading());
        final response = await repo.getActivity();
        emit(ActivityLoaded(response));
      } catch (e){
        emit(ActivityLoadFailure());
      }
    });
  }
}
