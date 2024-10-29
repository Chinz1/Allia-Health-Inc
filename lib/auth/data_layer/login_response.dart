class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final String chatToken;
  final Client client;

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.chatToken,
    required this.client,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken:
          json['body']['accessToken'] ?? '', // Corrected path for accessToken
      refreshToken:
          json['body']['refreshToken'] ?? '', // Corrected path for refreshToken
      chatToken:
          json['body']['chatToken'] ?? '', // Corrected path for chatToken
      client: Client.fromJson(json['body']['client']),
    );
  }
}

class Client {
  final int id;
  final String email;
  final String fcm;

  Client({
    required this.id,
    required this.email,
    required this.fcm,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      fcm: json['fcm'] ?? '',
    );
  }
}
