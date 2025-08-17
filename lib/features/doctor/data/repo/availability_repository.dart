import 'package:doctor_app/core/constants.dart';
import 'package:doctor_app/features/doctor/data/models/doctor_availability_model.dart';

abstract class AvailabilityRepository {
  Future<List<DoctorAvailability>> getDoctorAvailability(String doctorId);
  Future<void> upsertDoctorAvailability(DoctorAvailability availability);
}

class AvailabilityRepositoryImpl implements AvailabilityRepository {
  @override
  Future<List<DoctorAvailability>> getDoctorAvailability(
    String doctorId,
  ) async {
    try {
      final response = await supabase
          .from('doctor_availability')
          .select()
          .eq('doctor_id', doctorId)
          .order('day_of_week', ascending: true);
      return response.map(DoctorAvailability.fromMap).toList();
    } catch (e) {
      throw Exception('Failed to get availability: $e');
    }
  }

  @override
  Future<void> upsertDoctorAvailability(DoctorAvailability availability) async {
    try {
      await supabase
          .from('doctor_availability')
          .upsert(
            availability.toMap(),
            onConflict: 'doctor_id, day_of_week',
          );
    } catch (e) {
      throw Exception('Failed to save availability: $e');
    }
  }
}
