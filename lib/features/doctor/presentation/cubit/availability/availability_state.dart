part of 'availability_cubit.dart';

abstract class AvailabilityState extends Equatable {
  const AvailabilityState();
  @override
  List<Object> get props => [];
}

class AvailabilityInitial extends AvailabilityState {}

class AvailabilityLoading extends AvailabilityState {}

class AvailabilityLoaded extends AvailabilityState {
  const AvailabilityLoaded(this.availabilities);
  final List<DoctorAvailability> availabilities;
  @override
  List<Object> get props => [availabilities];
}

class AvailabilityError extends AvailabilityState {
  const AvailabilityError(this.message);
  final String message;
  @override
  List<Object> get props => [message];
}
