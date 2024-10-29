import 'package:allia_health_inc_test_app/auth/data_layer/login_request.dart';
import 'package:allia_health_inc_test_app/auth/data_layer/login_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthRepository {
  final String _baseUrl = 'https://api-dev.allia.health';

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/client/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    // Handle 201 status code as a successful login
    if (response.statusCode == 201 || response.statusCode == 200) {
      final responseBody = json.decode(response.body);

      // Check if response contains the expected structure
      if (responseBody.containsKey('body') &&
          responseBody['body'].containsKey('accessToken')) {
        return LoginResponse.fromJson(responseBody);
      } else {
        throw ('Invalid response format');
      }
    } else {
      final errorResponse = json.decode(response.body);
      String errorMessage = errorResponse['error'] ?? 'Failed to log in';
      throw Exception(errorMessage);
    }
  }

  // Refresh the access token using the refresh token
  Future<LoginResponse> refreshAccessToken(String refreshToken) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/client/auth/refresh-token'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = json.decode(response.body);
      return LoginResponse.fromJson(responseBody);
    } else {
      final errorResponse = json.decode(response.body);
      throw Exception('Failed to refresh token: ${errorResponse['error']}');
    }
  }
}
