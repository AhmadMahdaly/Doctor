import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DoctorAvailability {
  DoctorAvailability({
    required this.doctorId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.id,
  });

  factory DoctorAvailability.fromMap(Map<String, dynamic> map) {
    final startTimeStr = map['start_time'].toString().split(':');
    final endTimeStr = map['end_time'].toString().split(':');
    return DoctorAvailability(
      id: map['id'] as int?,
      doctorId: map['doctor_id'].toString(),
      dayOfWeek: map['day_of_week'] as int,
      startTime: TimeOfDay(
        hour: int.parse(startTimeStr[0]),
        minute: int.parse(startTimeStr[1]),
      ),
      endTime: TimeOfDay(
        hour: int.parse(endTimeStr[0]),
        minute: int.parse(endTimeStr[1]),
      ),
    );
  }
  final int? id;
  final String doctorId;
  final int dayOfWeek;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  Map<String, dynamic> toMap() {
    final format = DateFormat('HH:mm:ss');
    final now = DateTime.now();
    return {
      'doctor_id': doctorId,
      'day_of_week': dayOfWeek,
      'start_time': format.format(
        DateTime(
          now.year,
          now.month,
          now.day,
          startTime.hour,
          startTime.minute,
        ),
      ),
      'end_time': format.format(
        DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute),
      ),
    };
  }
}
