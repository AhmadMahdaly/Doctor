part of 'booking_cubit.dart';

abstract class BookingState extends Equatable {
  const BookingState();
  @override
  List<Object> get props => [];
}

class BookingInitial extends BookingState {}

class BookingPageLoading extends BookingState {}

class BookingSlotsLoading extends BookingState {}

class BookingPageReady extends BookingState {
  const BookingPageReady({
    required this.slots,
    required this.availableWeekdays,
  });
  final List<DateTime> slots;
  final List<int> availableWeekdays;

  @override
  List<Object> get props => [slots, availableWeekdays];

  BookingPageReady copyWith({
    List<DateTime>? slots,
    List<int>? availableWeekdays,
  }) {
    return BookingPageReady(
      slots: slots ?? this.slots,
      availableWeekdays: availableWeekdays ?? this.availableWeekdays,
    );
  }
}

class BookingSuccess extends BookingState {}

class BookingError extends BookingState {
  const BookingError(this.message);
  final String message;
  @override
  List<Object> get props => [message];
}
