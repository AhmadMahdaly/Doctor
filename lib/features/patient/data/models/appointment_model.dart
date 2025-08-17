// ignore_for_file: avoid_dynamic_calls

import 'package:doctor_app/features/auth/data/models/profile_model.dart';

class Appointment {
  Appointment({
    required this.patientId,
    required this.doctorId,
    required this.appointmentTime,
    this.id,
    this.status = 'confirmed',
    this.patient,
    this.doctor,
  });

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'] as int?,
      patientId: map['patient_id'].toString(),
      doctorId: map['doctor_id'].toString(),
      appointmentTime: DateTime.parse(map['appointment_time'].toString()),
      status: map['status'].toString(),
      patient: map['patient'] != null
          ? Profile.fromMap(map['patient'] as Map<String, dynamic>)
          : null,
      doctor: map['doctor'] != null
          ? Profile.fromMap(map['doctor'] as Map<String, dynamic>)
          : null,
    );
  }
  final int? id;
  final String patientId;
  final String doctorId;
  final DateTime appointmentTime;
  final String status;
  final Profile? patient;
  final Profile? doctor;

  Map<String, dynamic> toMap() {
    return {
      'patient_id': patientId,
      'doctor_id': doctorId,
      'appointment_time': appointmentTime.toIso8601String(),
      'status': status,
    };
  }
}
