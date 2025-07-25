class ProfileResponse {
  final String nisn;
  final String nik;
  final String name;
  final String password;
  final String placeOfBirth;
  final DateTime dateOfBirth;
  final String motherName;
  final String gender;
  final String level;

  ProfileResponse({
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

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return ProfileResponse(
      nisn: data['nisn'],
      nik: data['nik'],
      name: data['name'],
      password: data['password'],
      placeOfBirth: data['place_of_birth'],
      dateOfBirth: DateTime.parse(data['date_of_birth']),
      motherName: data['mother_name'],
      gender: data['gender'],
      level: data['level'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "nisn": nisn,
      "nik": nik,
      "name": name,
      "password": password,
      "place_of_birth": placeOfBirth,
      "date_of_birth": dateOfBirth.toIso8601String(),
      "mother_name": motherName,
      "gender": gender,
      "level": level,
    };
  }
}
