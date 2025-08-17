import 'package:doctor_app/features/app/cubits/cubit/history_cubit.dart';
import 'package:doctor_app/features/auth/data/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({required this.user, required this.profile, super.key});
  final User user;
  final Profile profile;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryCubit>().fetchHistory(
      widget.user.id,
      widget.profile.role,
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'confirmed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل المواعيد'),
      ),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HistoryLoaded) {
            if (state.appointments.isEmpty) {
              return const Center(child: Text('لا يوجد مواعيد في السجل.'));
            }
            return ListView.builder(
              itemCount: state.appointments.length,
              itemBuilder: (context, index) {
                final appointment = state.appointments[index];
                final isPatient = widget.profile.role == UserRole.patient;
                final title = isPatient
                    ? 'د. ${appointment.doctor?.fullName ?? 'غير معروف'}'
                    : 'المريض: ${appointment.patient?.fullName ?? 'غير معروف'}';

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text(title),
                    subtitle: Text(
                      DateFormat.yMMMMEEEEd('ar').add_Hm().format(
                        appointment.appointmentTime.toLocal(),
                      ),
                    ),
                    trailing: Chip(
                      label: Text(appointment.status),
                      backgroundColor: _getStatusColor(
                        appointment.status,
                      ).withAlpha(33),
                    ),
                  ),
                );
              },
            );
          }
          if (state is HistoryError) {
            return Center(child: Text('خطأ: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
