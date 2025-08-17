import 'package:doctor_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:doctor_app/features/patient/presentation/cubit/booking/booking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    context.read<BookingCubit>().loadBookingPage();
  }

  Future<void> _selectDate(BuildContext context) async {
    var availableWeekdays = <int>[];
    final currentState = context.read<BookingCubit>().state;
    if (currentState is BookingPageReady) {
      availableWeekdays = currentState.availableWeekdays;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      selectableDayPredicate: (DateTime day) {
        final dayOfWeek = day.weekday % 7 + 1;
        return availableWeekdays.contains(dayOfWeek);
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      await context.read<BookingCubit>().fetchAvailableSlots(_selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اختر موعداً')),
      body: BlocListener<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state is BookingSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم حجز الموعد بنجاح!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          } else if (state is BookingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'التاريخ المحدد: ${DateFormat.yMMMd().format(_selectedDate)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: BlocBuilder<BookingCubit, BookingState>(
                builder: (context, state) {
                  if (state is BookingPageLoading ||
                      state is BookingSlotsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is BookingPageReady) {
                    if (state.slots.isEmpty) {
                      return const Center(
                        child: Text('لا توجد مواعيد متاحة في هذا اليوم'),
                      );
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 2.5,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                      itemCount: state.slots.length,
                      itemBuilder: (context, index) {
                        final slot = state.slots[index];
                        return ElevatedButton(
                          onPressed: () {
                            final authState = context.read<AuthCubit>().state;
                            if (authState is AppAuthenticated) {
                              context.read<BookingCubit>().createAppointment(
                                slot,
                                authState.user.id,
                              );
                            }
                          },
                          child: Text(DateFormat.Hm().format(slot)),
                        );
                      },
                    );
                  }
                  if (state is BookingError) {
                    return Center(child: Text('خطأ: ${state.message}'));
                  }
                  return const Center(
                    child: Text('الرجاء اختيار يوم لعرض المواعيد'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
