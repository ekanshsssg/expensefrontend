part of 'activity_bloc.dart';

abstract class ActivityState extends Equatable {
  const ActivityState();
  @override
  List<Object> get props => [];
}

final class ActivityInitial extends ActivityState {}

final class ActivityLoading extends ActivityState {}

final class ActivityLoaded extends ActivityState {
  final List<Activity> activities;

  const ActivityLoaded(this.activities);

  @override
  List<Object> get props => [activities];
}

final class ActivityLoadFailure extends ActivityState {}
