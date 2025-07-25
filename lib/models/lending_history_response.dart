class LendingHistoryResponse {
  final String code;
  final List<LendingHistory> data;
  final String message;
  final bool success;

  LendingHistoryResponse({
    required this.code,
    required this.data,
    required this.message,
    required this.success,
  });

  factory LendingHistoryResponse.fromJson(Map<String, dynamic> json) {
    return LendingHistoryResponse(
      code: json['code'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => LendingHistory.fromJson(e))
              .toList() ??
          [],
      message: json['message'] ?? '',
      success: json['success'] ?? false,
    );
  }
}

class LendingHistory {
  final int id;
  final int bookId;
  final String bookTitle;
  final String bookAuthor;
  final String bookPublisher;
  final String bookIsbn;
  final int studentId;
  final String studentNisn;
  final String studentName;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  LendingHistory({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    required this.bookAuthor,
    required this.bookPublisher,
    required this.bookIsbn,
    required this.studentId,
    required this.studentNisn,
    required this.studentName,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LendingHistory.fromJson(Map<String, dynamic> json) {
    return LendingHistory(
      id: json['id'] ?? 0,
      bookId: json['book_id'] ?? 0,
      bookTitle: json['book_title'] ?? '',
      bookAuthor: json['book_author'] ?? '',
      bookPublisher: json['book_publisher'] ?? '',
      bookIsbn: json['book_isbn'] ?? '',
      studentId: json['student_id'] ?? 0,
      studentNisn: json['student_nisn'] ?? '',
      studentName: json['student_name'] ?? '',
      status: json['status'] ?? '',
      startDate: DateTime.tryParse(json['start_date'] ?? '') ?? DateTime(2000),
      endDate: DateTime.tryParse(json['end_date'] ?? '') ?? DateTime(2000),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime(2000),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime(2000),
    );
  }
}
