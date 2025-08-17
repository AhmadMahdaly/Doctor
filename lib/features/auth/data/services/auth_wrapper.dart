import 'package:doctor_app/features/auth/data/models/profile_model.dart';
import 'package:doctor_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:doctor_app/features/doctor/presentation/views/doctor_home_screen.dart';
import 'package:doctor_app/features/auth/presentation/views/login_screen.dart';
import 'package:doctor_app/features/patient/presentation/views/patient_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AppAuthState>(
      builder: (context, state) {
        if (state is AppAuthenticated) {
          if (state.profile.role == UserRole.doctor) {
            return const DoctorHomeScreen();
          } else {
            return const PatientHomeScreen();
          }
        } else if (state is AppUnauthenticated) {
          return const LoginScreen();
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
