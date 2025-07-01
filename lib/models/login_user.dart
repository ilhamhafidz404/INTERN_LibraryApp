class LoginUser {
  final int id;
  final String name;
  final String nisn;
  final String nik;
  final String placeAndDateOfBirth;
  final String motherName;
  final String gender;
  final String level;

  LoginUser({
    required this.id,
    required this.name,
    required this.nisn,
    required this.nik,
    required this.placeAndDateOfBirth,
    required this.motherName,
    required this.gender,
    required this.level,
  });

  factory LoginUser.fromJson(Map<String, dynamic> json) {
    return LoginUser(
      id: json['id'],
      name: json['name'],
      nisn: json['nisn'],
      nik: json['nik'],
      placeAndDateOfBirth: json['place_and_date_of_birth'],
      motherName: json['mother_name'],
      gender: json['gender'],
      level: json['level'],
    );
  }
}
