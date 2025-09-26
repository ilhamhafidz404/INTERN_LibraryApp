class StudentResponse {
  final String code;
  final List<Student> data;
  final String message;
  final bool success;

  StudentResponse({
    required this.code,
    required this.data,
    required this.message,
    required this.success,
  });

  factory StudentResponse.fromJson(Map<String, dynamic> json) {
    return StudentResponse(
      code: json['code'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => Student.fromJson(item))
              .toList() ??
          [],
      message: json['message'] ?? '',
      success: json['success'] ?? false,
    );
  }
}

class Student {
  final int id;
  final String nisn;
  final String nik;
  final String name;
  final String password;
  final String placeOfBirth;
  final DateTime dateOfBirth;
  final String motherName;
  final String gender;
  final String level;

  Student({
    required this.id,
    required this.nisn,
    required this.nik,
    required this.name,
    required this.password,
    required this.placeOfBirth,
    required this.dateOfBirth,
    required this.motherName,
    required this.gender,
    required this.level,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? 0,
      nisn: json['nisn'] ?? '',
      nik: json['nik'] ?? '',
      name: json['name'] ?? '',
      password: json['password'] ?? '',
      placeOfBirth: json['place_of_birth'] ?? '',
      dateOfBirth:
          DateTime.tryParse(json['date_of_birth'] ?? '') ?? DateTime(2000),
      motherName: json['mother_name'] ?? '',
      gender: json['gender'] ?? '',
      level: json['level'] ?? '',
    );
  }
}

class StudentSingleResponse {
  final String code;
  final Student? data;
  final String message;
  final bool success;

  StudentSingleResponse({
    required this.code,
    this.data,
    required this.message,
    required this.success,
  });

  factory StudentSingleResponse.fromJson(Map<String, dynamic> json) {
    return StudentSingleResponse(
      code: json['code'] ?? '',
      data: json['data'] != null ? Student.fromJson(json['data']) : null,
      message: json['message'] ?? '',
      success: json['success'] ?? false,
    );
  }
}
