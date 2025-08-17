import 'package:bloc/bloc.dart';
import 'package:doctor_app/features/patient/data/models/appointment_model.dart';
import 'package:doctor_app/features/patient/data/repo/appointment_repository.dart';
import 'package:equatable/equatable.dart';

part 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  ScheduleCubit(this._appointmentRepository) : super(ScheduleInitial());
  final AppointmentRepository _appointmentRepository;

  void fetchSchedule(String doctorId) {
    emit(ScheduleLoading());
    try {
      _appointmentRepository.getDoctorAppointments(doctorId).listen((
        appointments,
      ) {
        emit(ScheduleLoaded(appointments));
      });
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }
}
