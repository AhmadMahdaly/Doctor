import 'package:bloc/bloc.dart';
import 'package:doctor_app/features/doctor/data/models/doctor_availability_model.dart';
import 'package:doctor_app/features/doctor/data/repo/availability_repository.dart';
import 'package:equatable/equatable.dart';

part 'availability_state.dart';

class AvailabilityCubit extends Cubit<AvailabilityState> {
  AvailabilityCubit(this._availabilityRepository)
    : super(AvailabilityInitial());
  final AvailabilityRepository _availabilityRepository;

  Future<void> getAvailability(String doctorId) async {
    emit(AvailabilityLoading());
    try {
      final availabilities = await _availabilityRepository
          .getDoctorAvailability(doctorId);
      emit(AvailabilityLoaded(availabilities));
    } catch (e) {
      emit(AvailabilityError(e.toString()));
    }
  }

  Future<void> saveAvailability(DoctorAvailability availability) async {
    try {
      await _availabilityRepository.upsertDoctorAvailability(availability);
      await getAvailability(availability.doctorId);
    } catch (e) {
      emit(AvailabilityError(e.toString()));
    }
  }
}
