part of 'history_cubit.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();
  @override
  List<Object> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  const HistoryLoaded(this.appointments);
  final List<Appointment> appointments;
  @override
  List<Object> get props => [appointments];
}

class HistoryError extends HistoryState {
  const HistoryError(this.message);
  final String message;
  @override
  List<Object> get props => [message];
}
