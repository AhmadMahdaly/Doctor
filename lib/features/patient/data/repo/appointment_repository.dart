import 'dart:developer';

import 'package:doctor_app/core/constants.dart';
import 'package:doctor_app/features/auth/data/models/profile_model.dart';
import 'package:doctor_app/features/patient/data/models/appointment_model.dart';
import 'package:flutter/material.dart';

abstract class AppointmentRepository {
  Future<List<DateTime>> getAvailableSlots(String doctorId, DateTime date);
  Future<void> createAppointment(Appointment appointment);
  Stream<List<Appointment>> getDoctorAppointments(String doctorId);
  Future<List<Appointment>> getAppointmentHistory(String userId, UserRole role);
}

class AppointmentRepositoryImpl implements AppointmentRepository {
  @override
  Future<void> createAppointment(Appointment appointment) async {
    try {
      await supabase.from('appointments').insert(appointment.toMap());
    } catch (e) {
      throw Exception('Error creating appointment: $e');
    }
  }

  @override
  Stream<List<Appointment>> getDoctorAppointments(String doctorId) {
    final appointmentStream = supabase
        .from('appointments')
        .stream(primaryKey: ['id'])
        .eq('doctor_id', doctorId)
        .order('appointment_time', ascending: true);

    return appointmentStream.asyncMap((listOfMaps) async {
      final appointmentsWithNames = await Future.wait(
        listOfMaps.map((map) async {
          final patientId = map['patient_id'];
          if (patientId != null) {
            try {
              final profileResponse = await supabase
                  .from('profiles')
                  .select('full_name')
                  .eq('id', patientId.toString())
                  .single();

              map['profiles'] = {'full_name': profileResponse['full_name']};
            } catch (e) {
              log(e.toString());

              log('Could not fetch profile for patientId $patientId: $e');
              map['profiles'] = {'full_name': 'Unknown Patient'};
            }
          }
          return Appointment.fromMap(map);
        }).toList(),
      );

      return appointmentsWithNames;
    });
  }

  @override
  Future<List<Appointment>> getAppointmentHistory(
    String userId,
    UserRole role,
  ) async {
    final query = role == UserRole.patient
        ? '*, doctor:doctor_id(*)'
        : '*, patient:patient_id(*)';

    final response = await supabase
        .from('appointments')
        .select(query)
        .eq(role == UserRole.patient ? 'patient_id' : 'doctor_id', userId)
        .order('appointment_time', ascending: false);

    return response.map(Appointment.fromMap).toList();
  }

  @override
  Future<List<DateTime>> getAvailableSlots(
    String doctorId,
    DateTime date,
  ) async {
    try {
      final dayOfWeek = date.weekday % 7 + 1;
      final availabilityResponse = await supabase
          .from('doctor_availability')
          .select('start_time, end_time')
          .eq('doctor_id', doctorId)
          .eq('day_of_week', dayOfWeek)
          .maybeSingle();

      if (availabilityResponse == null) {
        return [];
      }

      final startTimeStr = availabilityResponse['start_time'] as String;
      final endTimeStr = availabilityResponse['end_time'] as String;

      final startTime = TimeOfDay(
        hour: int.parse(startTimeStr.split(':')[0]),
        minute: int.parse(startTimeStr.split(':')[1]),
      );
      final endTime = TimeOfDay(
        hour: int.parse(endTimeStr.split(':')[0]),
        minute: int.parse(endTimeStr.split(':')[1]),
      );

      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final bookedAppointmentsResponse = await supabase
          .from('appointments')
          .select('appointment_time')
          .eq('doctor_id', doctorId)
          .gte('appointment_time', startOfDay.toIso8601String())
          .lt('appointment_time', endOfDay.toIso8601String());

      final bookedSlots = bookedAppointmentsResponse
          .map<DateTime>(
            (map) => DateTime.parse(map['appointment_time'].toString()),
          )
          .toList();

      final availableSlots = <DateTime>[];
      var currentTime = DateTime(
        date.year,
        date.month,
        date.day,
        startTime.hour,
        startTime.minute,
      );
      final closingTime = DateTime(
        date.year,
        date.month,
        date.day,
        endTime.hour,
        endTime.minute,
      );

      while (currentTime.isBefore(closingTime)) {
        if (!bookedSlots.any(
          (booked) => booked.isAtSameMomentAs(currentTime),
        )) {
          availableSlots.add(currentTime);
        }
        currentTime = currentTime.add(const Duration(hours: 1));
      }

      return availableSlots;
    } catch (e) {
      log('Error getting available slots: $e');
      return [];
    }
  }
}
