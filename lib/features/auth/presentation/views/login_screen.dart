import 'package:doctor_app/core/responsive/responsive_config.dart';
import 'package:doctor_app/features/auth/data/models/profile_model.dart';
import 'package:doctor_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:doctor_app/features/auth/presentation/views/signup_screen.dart';
import 'package:doctor_app/features/doctor/presentation/views/doctor_home_screen.dart';
import 'package:doctor_app/features/patient/presentation/views/patient_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      body: BlocConsumer<AuthCubit, AppAuthState>(
        listener: (context, state) {
          if (state is AppAuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is AppAuthenticated) {
            if (state.profile.role == UserRole.doctor) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const DoctorHomeScreen(),
                ),
              );
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const PatientHomeScreen(),
                ),
              );
            }
          }
        },
        builder: (context, state) {
          if (state is AppAuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'البريد الإلكتروني',
                  ),
                  validator: (value) => value!.isEmpty ? 'الحقل مطلوب' : null,
                ),
                12.verticalSpace,
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'كلمة المرور'),
                  obscureText: true,
                  validator: (value) => value!.isEmpty ? 'الحقل مطلوب' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<AuthCubit>().signIn(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );
                    }
                  },
                  child: const Text('دخول'),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('ليس لديك حساب؟'),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: const Text('أنشئ حساباً'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
