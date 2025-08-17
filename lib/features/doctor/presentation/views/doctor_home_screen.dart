import 'package:doctor_app/features/app/views/history_screen.dart';
import 'package:doctor_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:doctor_app/features/doctor/presentation/views/manage_availability_screen.dart';
import 'package:doctor_app/features/patient/presentation/cubit/schedule/schedule_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthCubit>().state;
    if (authState is AppAuthenticated) {
      context.read<ScheduleCubit>().fetchSchedule(authState.user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    // ignore: unused_local_variable
    var doctorName = '';
    if (authState is AppAuthenticated) {
      doctorName = authState.profile.fullName ?? 'دكتور';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('المواعيد القادمة'),
        actions: [
          IconButton(
            tooltip: 'سجل المواعيد',
            icon: const Icon(Icons.history),
            onPressed: () {
              if (authState is AppAuthenticated) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => HistoryScreen(
                      user: authState.user,
                      profile: authState.profile,
                    ),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthCubit>().signOut(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ManageAvailabilityScreen()),
          );
        },
        icon: const Icon(Icons.edit_calendar),
        label: const Text('إدارة أوقات العمل'),
      ),
      body: BlocBuilder<ScheduleCubit, ScheduleState>(
        builder: (context, state) {
          if (state is ScheduleLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ScheduleLoaded) {
            if (state.appointments.isEmpty) {
              return const Center(child: Text('لا توجد مواعيد قادمة.'));
            }
            return ListView.builder(
              itemCount: state.appointments.length,
              itemBuilder: (context, index) {
                final appointment = state.appointments[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(
                      'المريض: ${appointment.patient?.fullName ?? 'غير معروف'}',
                    ),
                    subtitle: Text(
                      'الوقت: ${DateFormat.yMMMMEEEEd('ar').add_Hm().format(appointment.appointmentTime.toLocal())}',
                    ),
                    trailing: Text(
                      appointment.status,
                      style: TextStyle(color: Colors.green.shade700),
                    ),
                  ),
                );
              },
            );
          }
          if (state is ScheduleError) {
            return Center(child: Text('خطأ: ${state.message}'));
          }
          return const Center(child: Text('جاري تحميل الجدول...'));
        },
      ),
    );
  }
}
