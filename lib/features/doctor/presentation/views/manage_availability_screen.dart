import 'dart:developer';

import 'package:doctor_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:doctor_app/features/doctor/presentation/cubit/availability/availability_cubit.dart';
import 'package:doctor_app/features/doctor/data/models/doctor_availability_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageAvailabilityScreen extends StatefulWidget {
  const ManageAvailabilityScreen({super.key});

  @override
  State<ManageAvailabilityScreen> createState() =>
      _ManageAvailabilityScreenState();
}

class _ManageAvailabilityScreenState extends State<ManageAvailabilityScreen> {
  final List<String> daysOfWeek = [
    'الأحد',
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
  ];

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthCubit>().state;
    if (authState is AppAuthenticated) {
      context.read<AvailabilityCubit>().getAvailability(authState.user.id);
    }
  }

  String _getDayName(int dayOfWeek) {
    return daysOfWeek[dayOfWeek - 1];
  }

  Future<void> _showTimePickerModal(
    BuildContext context,
    int day,
    DoctorAvailability? currentAvailability,
  ) async {
    TimeOfDay? startTime =
        currentAvailability?.startTime ?? const TimeOfDay(hour: 9, minute: 0);
    TimeOfDay? endTime =
        currentAvailability?.endTime ?? const TimeOfDay(hour: 17, minute: 0);
    final authState = context.read<AuthCubit>().state;
    if (authState is! AppAuthenticated) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (stfContext, stfSetState) {
            return AlertDialog(
              title: Text('تعديل أوقات عمل يوم ${_getDayName(day)}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Start Time
                  ListTile(
                    title: const Text('وقت البدء'),
                    trailing: Text(startTime!.format(context)),
                    onTap: () async {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: startTime!,
                      );
                      if (pickedTime != null) {
                        stfSetState(() {
                          startTime = pickedTime;
                        });
                      }
                    },
                  ),
                  // End Time
                  ListTile(
                    title: const Text('وقت الانتهاء'),
                    trailing: Text(endTime!.format(context)),
                    onTap: () async {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: endTime!,
                      );
                      if (pickedTime != null) {
                        stfSetState(() {
                          endTime = pickedTime;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('إلغاء'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final newAvailability = DoctorAvailability(
                      doctorId: authState.user.id,
                      dayOfWeek: day,
                      startTime: startTime!,
                      endTime: endTime!,
                    );
                    context.read<AvailabilityCubit>().saveAvailability(
                      newAvailability,
                    );
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('حفظ'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة أوقات العمل'),
      ),
      body: BlocConsumer<AvailabilityCubit, AvailabilityState>(
        listener: (context, state) {
          if (state is AvailabilityError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
            log(state.message);
          }
        },
        builder: (context, state) {
          if (state is AvailabilityLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AvailabilityLoaded) {
            return ListView.builder(
              itemCount: 7,
              itemBuilder: (context, index) {
                final day = index + 1; // 1 for Sunday, 7 for Saturday
                final availabilityForDay = state.availabilities.firstWhere(
                  (a) => a.dayOfWeek == day,
                  orElse: () => DoctorAvailability(
                    doctorId: '',
                    dayOfWeek: 0,
                    startTime: const TimeOfDay(hour: 0, minute: 0),
                    endTime: const TimeOfDay(hour: 0, minute: 0),
                  ),
                );
                final isSet = availabilityForDay.doctorId.isNotEmpty;

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text(
                      _getDayName(day),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      isSet
                          ? 'من ${availabilityForDay.startTime.format(context)} إلى ${availabilityForDay.endTime.format(context)}'
                          : 'غير محدد',
                    ),
                    trailing: const Icon(Icons.edit),
                    onTap: () {
                      _showTimePickerModal(
                        context,
                        day,
                        isSet ? availabilityForDay : null,
                      );
                    },
                  ),
                );
              },
            );
          }
          return const Center(child: Text('لا توجد بيانات'));
        },
      ),
    );
  }
}
