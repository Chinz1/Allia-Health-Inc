// auth_event.dart
abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});
}

// New event for handling token expiration
class TokenExpired extends AuthEvent {
  final String refreshToken;

  TokenExpired({required this.refreshToken});
}