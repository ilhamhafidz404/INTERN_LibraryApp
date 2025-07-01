import 'package:intern_libraryapp/models/login_data.dart';

class LoginResponse {
  final String code;
  final LoginData data;
  final String message;
  final bool success;

  LoginResponse({
    required this.code,
    required this.data,
    required this.message,
    required this.success,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      code: json['code'],
      data: LoginData.fromJson(json['data']),
      message: json['message'],
      success: json['success'],
    );
  }
}
