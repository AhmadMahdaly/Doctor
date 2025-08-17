part of 'auth_cubit.dart';

abstract class AppAuthState extends Equatable {
  const AppAuthState();
  @override
  List<Object?> get props => [];
}

class AppAuthInitial extends AppAuthState {}

class AppAuthLoading extends AppAuthState {}

class AppAuthenticated extends AppAuthState {
  const AppAuthenticated({required this.user, required this.profile});
  final User user;
  final Profile profile;
  @override
  List<Object?> get props => [user, profile];
}

class AppUnauthenticated extends AppAuthState {}

class AppAuthError extends AppAuthState {
  const AppAuthError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
