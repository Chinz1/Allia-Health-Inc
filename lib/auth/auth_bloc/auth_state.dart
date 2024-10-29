// auth_state.dart
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String accessToken;
  final String refreshToken;
  final String chatToken;
  final int clientId;

  AuthSuccess({
    required this.accessToken,
    required this.refreshToken,
    required this.chatToken,
    required this.clientId,
  });
}



class AuthFailure extends AuthState {
  final String error;

  AuthFailure(this.error);
}
