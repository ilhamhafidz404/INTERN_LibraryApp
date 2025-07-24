class BookResponse {
  final String code;
  final List<Book> data;
  final String message;
  final bool success;

  BookResponse({
    required this.code,
    required this.data,
    required this.message,
    required this.success,
  });

  factory BookResponse.fromJson(Map<String, dynamic> json) {
    return BookResponse(
      code: json['code'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => Book.fromJson(item))
              .toList() ??
          [],
      message: json['message'] ?? '',
      success: json['success'] ?? false,
    );
  }
}

class Book {
  final int id;
  final String cover;
  final String title;
  final String publisher;
  final String author;
  final String isbn;
  final int year;
  final int total;
  final int createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  Book({
    required this.id,
    required this.cover,
    required this.title,
    required this.publisher,
    required this.author,
    required this.isbn,
    required this.year,
    required this.total,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] ?? 0,
      cover: json['cover'] ?? '',
      title: json['title'] ?? '',
      publisher: json['publisher'] ?? '',
      author: json['author'] ?? '',
      isbn: json['isbn'] ?? '',
      year: json['year'] ?? 0,
      total: json['total'] ?? 0,
      createdBy: json['created_by'] ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime(2000),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime(2000),
    );
  }
}
