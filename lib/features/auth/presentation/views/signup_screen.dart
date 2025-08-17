import 'package:doctor_app/features/auth/data/models/profile_model.dart';
import 'package:doctor_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  UserRole _selectedRole = UserRole.patient;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء حساب جديد')),
      body: BlocConsumer<AuthCubit, AppAuthState>(
        listener: (context, state) {
          if (state is AppAuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AppUnauthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'تم إنشاء الحساب بنجاح! الرجاء مراجعة بريدك الإلكتروني للتفعيل ثم قم بتسجيل الدخول.',
                ),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 5),
              ),
            );
            Navigator.of(context).pop();
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
                  controller: _fullNameController,
                  decoration: const InputDecoration(labelText: 'الاسم الكامل'),
                  validator: (value) => value!.isEmpty ? 'الحقل مطلوب' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'البريد الإلكتروني',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value!.isEmpty ? 'الحقل مطلوب' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'كلمة المرور'),
                  obscureText: true,
                  validator: (value) => (value?.length ?? 0) < 6
                      ? 'كلمة المرور يجب أن تكون 6 أحرف على الأقل'
                      : null,
                ),
                const SizedBox(height: 20),
                const Text('اختر دورك:', style: TextStyle(fontSize: 16)),
                RadioListTile<UserRole>(
                  title: const Text('مريض'),
                  value: UserRole.patient,
                  groupValue: _selectedRole,
                  onChanged: (UserRole? value) {
                    setState(() {
                      _selectedRole = value!;
                    });
                  },
                ),
                RadioListTile<UserRole>(
                  title: const Text('طبيب'),
                  value: UserRole.doctor,
                  groupValue: _selectedRole,
                  onChanged: (UserRole? value) {
                    setState(() {
                      _selectedRole = value!;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<AuthCubit>().signUp(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                        _fullNameController.text.trim(),
                        _selectedRole,
                      );
                    }
                  },
                  child: const Text('إنشاء حساب'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
