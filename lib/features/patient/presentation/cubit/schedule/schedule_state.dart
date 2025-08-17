part of 'schedule_cubit.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();
  @override
  List<Object> get props => [];
}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  const ScheduleLoaded(this.appointments);
  final List<Appointment> appointments;
  @override
  List<Object> get props => [appointments];
}

class ScheduleError extends ScheduleState {
  const ScheduleError(this.message);
  final String message;
  @override
  List<Object> get props => [message];
}
