class DashboardResponse {
  final bool success;
  final String message;
  final Dashboard data;

  DashboardResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: Dashboard.fromJson(json['data']),
    );
  }
}

class Dashboard {
  final int totalBook;
  final int totalAdmin;
  final int totalStudent;

  Dashboard({
    required this.totalBook,
    required this.totalAdmin,
    required this.totalStudent,
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    return Dashboard(
      totalBook: json['total_book'] ?? 0,
      totalAdmin: json['total_admin'] ?? 0,
      totalStudent: json['total_student'] ?? 0,
    );
  }
}
