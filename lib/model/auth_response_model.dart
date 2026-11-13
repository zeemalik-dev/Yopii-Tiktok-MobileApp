import 'package:createex_task_application/model/user_model.dart';

class AuthResponse {
  final String status;
  final String message;
  final User user;
  final String token;

  AuthResponse({
    required this.status,
    required this.message,
    required this.user,
    required this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      user: User.fromJson(json['data']['user']),
      token: json['data']['token'] ?? '',
    );
  }
}
