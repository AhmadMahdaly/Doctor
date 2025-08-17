import 'package:bloc/bloc.dart';
import 'package:doctor_app/features/auth/data/models/profile_model.dart';
import 'package:doctor_app/features/patient/data/models/appointment_model.dart';
import 'package:doctor_app/features/patient/data/repo/appointment_repository.dart';
import 'package:equatable/equatable.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit(this._appointmentRepository) : super(HistoryInitial());
  final AppointmentRepository _appointmentRepository;

  Future<void> fetchHistory(String userId, UserRole role) async {
    emit(HistoryLoading());
    try {
      final appointments = await _appointmentRepository.getAppointmentHistory(
        userId,
        role,
      );
      emit(HistoryLoaded(appointments));
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }
}
