
import 'package:project_zed/shared/error/failure.dart';

class AuthState {
  final AuthStateEnum state;
  final String? message;
  final Failure? error;

  const AuthState({
    required this.state,
    this.message,
    this.error,
  });

  factory AuthState.fromEnum(AuthStateEnum state) {
    return AuthState(state: state);
  }

  factory AuthState.success(String message) {
    return AuthState(state: AuthStateEnum.authSuccess, message: message);
  }

  factory AuthState.error(Failure failure) {
    return AuthState(state: AuthStateEnum.authError, error: failure);
  }
}

enum AuthStateEnum {
  authInitial,
  authLoading,
  authSuccess,
  authError,
}
