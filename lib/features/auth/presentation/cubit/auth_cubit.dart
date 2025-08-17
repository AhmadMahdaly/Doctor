import 'package:bloc/bloc.dart';
import 'package:doctor_app/features/auth/data/models/profile_model.dart';
import 'package:doctor_app/features/auth/data/repo/auth_repository.dart';
import 'package:doctor_app/features/auth/data/repo/profile_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AppAuthState> {
  AuthCubit(this._authRepository, this._profileRepository)
    : super(AppAuthInitial()) {
    _authRepository.authStateChanges.listen((authState) async {
      if (authState.session?.user != null) {
        final user = authState.session!.user;
        final profile = await _profileRepository.getProfile(user.id);
        if (profile != null) {
          emit(AppAuthenticated(user: user, profile: profile));
        } else {
          emit(AppUnauthenticated());
        }
      } else {
        emit(AppUnauthenticated());
      }
    });
  }
  final AuthRepository _authRepository;
  final ProfileRepository _profileRepository;

  Future<void> signUp(
    String email,
    String password,
    String fullName,
    UserRole role,
  ) async {
    emit(AppAuthLoading());
    try {
      await _authRepository.signUp(
        email: email,
        password: password,
        fullName: fullName,
        role: role,
      );
    } catch (e) {
      emit(AppAuthError(e.toString()));
    }
  }

  Future<void> signIn(String email, String password) async {
    emit(AppAuthLoading());
    try {
      await _authRepository.signIn(email: email, password: password);
    } catch (e) {
      emit(AppAuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(AppAuthLoading());
    try {
      await _authRepository.signOut();
      emit(AppUnauthenticated());
    } catch (e) {
      emit(AppAuthError(e.toString()));
    }
  }
}
