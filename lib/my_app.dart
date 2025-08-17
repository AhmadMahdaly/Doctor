import 'package:doctor_app/core/di.dart';
import 'package:doctor_app/core/localization/s.dart';
import 'package:doctor_app/core/responsive/responsive_config.dart';
import 'package:doctor_app/core/theme/app_themes.dart';
import 'package:doctor_app/features/app/cubits/cubit/history_cubit.dart';
import 'package:doctor_app/features/auth/data/services/auth_wrapper.dart';
import 'package:doctor_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:doctor_app/features/doctor/presentation/cubit/availability/availability_cubit.dart';
import 'package:doctor_app/features/patient/presentation/cubit/booking/booking_cubit.dart';
import 'package:doctor_app/features/patient/presentation/cubit/schedule/schedule_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return GestureDetector(
      onTap: () => unfocusScope(context),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => getIt<AuthCubit>()),
          BlocProvider(create: (context) => getIt<BookingCubit>()),
          BlocProvider(create: (context) => getIt<ScheduleCubit>()),
          BlocProvider(create: (context) => getIt<AvailabilityCubit>()),
          BlocProvider(create: (context) => getIt<HistoryCubit>()),
        ],
        child: MaterialApp(
          title: 'Doctor',
          debugShowCheckedModeBanner: false,
          home: const AuthWrapper(),
          theme: Appthemes.lightTheme(),
          locale: const Locale('ar'),
          supportedLocales: const [Locale('ar')],
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        ),
      ),
    );
  }
}
