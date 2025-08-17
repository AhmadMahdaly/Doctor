import 'package:doctor_app/core/constants.dart';
import 'package:doctor_app/features/auth/data/models/profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  User? get currentUser;
  Stream<AuthState> get authStateChanges;
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
  });
  Future<void> signIn({required String email, required String password});
  Future<void> signOut();
}

class AuthRepositoryImpl implements AuthRepository {
  final GoTrueClient _auth = supabase.auth;

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Stream<AuthState> get authStateChanges => _auth.onAuthStateChange;

  @override
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithPassword(email: email, password: password);
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
  }) async {
    try {
      await _auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'role': role == UserRole.doctor ? 'doctor' : 'patient',
        },
      );
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }
}
