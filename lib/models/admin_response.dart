class AdminResponse {
  final String code;
  final List<Admin> data;
  final String message;
  final bool success;

  AdminResponse({
    required this.code,
    required this.data,
    required this.message,
    required this.success,
  });

  factory AdminResponse.fromJson(Map<String, dynamic> json) {
    return AdminResponse(
      code: json['code'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => Admin.fromJson(item))
              .toList() ??
          [],
      message: json['message'] ?? '',
      success: json['success'] ?? false,
    );
  }
}

class Admin {
  final int id;
  final String name;
  final String username;
  final String password;

  Admin({
    required this.id,
    required this.name,
    required this.username,
    required this.password,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
    );
  }
}

class AdminSingleResponse {
  final String code;
  final Admin? data;
  final String message;
  final bool success;

  AdminSingleResponse({
    required this.code,
    this.data,
    required this.message,
    required this.success,
  });

  factory AdminSingleResponse.fromJson(Map<String, dynamic> json) {
    return AdminSingleResponse(
      code: json['code'] ?? '',
      data: json['data'] != null ? Admin.fromJson(json['data']) : null,
      message: json['message'] ?? '',
      success: json['success'] ?? false,
    );
  }
}
