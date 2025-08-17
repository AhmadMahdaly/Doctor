import 'package:doctor_app/features/app/cubits/cubit/history_cubit.dart';
import 'package:doctor_app/features/auth/data/repo/auth_repository.dart';
import 'package:doctor_app/features/auth/data/repo/profile_repository.dart';
import 'package:doctor_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:doctor_app/features/doctor/data/repo/availability_repository.dart';
import 'package:doctor_app/features/doctor/presentation/cubit/availability/availability_cubit.dart';
import 'package:doctor_app/features/patient/data/repo/appointment_repository.dart';
import 'package:doctor_app/features/patient/presentation/cubit/booking/booking_cubit.dart';
import 'package:doctor_app/features/patient/presentation/cubit/schedule/schedule_cubit.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Repositories
  getIt
    ..registerLazySingleton<AuthRepository>(() {
      return AuthRepositoryImpl();
    })
    ..registerLazySingleton<ProfileRepository>(() {
      return ProfileRepositoryImpl();
    })
    ..registerLazySingleton<AppointmentRepository>(() {
      return AppointmentRepositoryImpl();
    })
    ..registerLazySingleton<AvailabilityRepository>(() {
      return AvailabilityRepositoryImpl();
    })
    // Cubits
    ..registerFactory(() => AuthCubit(getIt(), getIt()))
    ..registerFactory(() => BookingCubit(getIt(), getIt(), getIt()))
    ..registerFactory(() => ScheduleCubit(getIt()))
    ..registerFactory(() => AvailabilityCubit(getIt()))
    ..registerFactory(() => HistoryCubit(getIt()));
}
