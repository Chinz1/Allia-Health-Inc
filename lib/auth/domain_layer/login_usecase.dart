import 'package:allia_health_inc_test_app/auth/data_layer/login_request.dart';
import 'package:allia_health_inc_test_app/auth/data_layer/login_response.dart';
import 'package:allia_health_inc_test_app/auth/repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<LoginResponse> call(String email, String password) {
    return repository.login(LoginRequest(email: email, password: password));
  }

   // Refresh token
  Future<LoginResponse> refreshAccessToken(String refreshToken) {
    return repository.refreshAccessToken(refreshToken);
  }
}



