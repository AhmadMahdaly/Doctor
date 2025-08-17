import 'package:bloc/bloc.dart';
import 'package:doctor_app/features/auth/data/repo/profile_repository.dart';
import 'package:doctor_app/features/doctor/data/repo/availability_repository.dart';
import 'package:doctor_app/features/patient/data/models/appointment_model.dart';
import 'package:doctor_app/features/patient/data/repo/appointment_repository.dart';
import 'package:equatable/equatable.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit(
    this._appointmentRepository,
    this._profileRepository,
    this._availabilityRepository,
  ) : super(BookingInitial());
  final AppointmentRepository _appointmentRepository;
  final ProfileRepository _profileRepository;
  final AvailabilityRepository _availabilityRepository;

  Future<void> loadBookingPage() async {
    emit(BookingPageLoading());
    try {
      final doctor = await _profileRepository.getDoctor();
      if (doctor == null) {
        emit(const BookingError('لا يوجد طبيب متاح في النظام'));
        return;
      }

      final weeklyAvailability = await _availabilityRepository
          .getDoctorAvailability(doctor.id);
      final availableWeekdays = weeklyAvailability
          .map((a) => a.dayOfWeek)
          .toList();

      final slots = await _appointmentRepository.getAvailableSlots(
        doctor.id,
        DateTime.now(),
      );

      emit(
        BookingPageReady(slots: slots, availableWeekdays: availableWeekdays),
      );
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> fetchAvailableSlots(DateTime date) async {
    final currentState = state;
    if (currentState is! BookingPageReady)
      return; 

    emit(BookingSlotsLoading());
    try {
      final doctor = await _profileRepository.getDoctor();
      if (doctor == null) {
        emit(const BookingError('لا يوجد طبيب متاح في النظام'));
        return;
      }
      final slots = await _appointmentRepository.getAvailableSlots(
        doctor.id,
        date,
      );
      emit(currentState.copyWith(slots: slots));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> createAppointment(DateTime slot, String patientId) async {
    try {
      final doctor = await _profileRepository.getDoctor();
      if (doctor == null) {
        emit(const BookingError('لا يوجد طبيب متاح في النظام'));
        return;
      }
      final appointment = Appointment(
        patientId: patientId,
        doctorId: doctor.id,
        appointmentTime: slot,
      );
      await _appointmentRepository.createAppointment(appointment);
      emit(BookingSuccess());
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }
}
