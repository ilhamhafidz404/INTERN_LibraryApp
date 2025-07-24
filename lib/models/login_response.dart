class LoginResponse {
  final String code;
  final String message;
  final bool success;
  final Data? data;

  LoginResponse({
    required this.code,
    required this.message,
    required this.success,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      success: json['success'] ?? false,
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }
}

class Data {
  final String token;
  final Auth? auth;

  Data({required this.token, this.auth});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      token: json['token'] ?? '',
      auth: json['auth'] != null ? Auth.fromJson(json['auth']) : null,
    );
  }
}

class Auth {
  final int id;
  final String name;
  final String username;
  final String level;

  Auth({
    required this.id,
    required this.name,
    required this.username,
    required this.level,
  });

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      level: json['level'] ?? '',
    );
  }
}
