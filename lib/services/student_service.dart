import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/student_response.dart';

class StudentService {
  final String baseUrl = "http://202.10.36.222:3000/api";

  /// Get all students
  Future<StudentResponse> getStudents() async {
    final url = Uri.parse('$baseUrl/students');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('Token tidak tersedia. Silakan login kembali.');
    }

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        return StudentResponse.fromJson(jsonData);
      } catch (e) {
        throw Exception('Gagal parsing response: $e');
      }
    } else {
      throw Exception('Gagal mengambil data siswa: ${response.body}');
    }
  }

  /// Create student
  Future<StudentSingleResponse> createStudent({
    required String nisn,
    required String nik,
    required String name,
    required String password,
    required String confirmationPassword,
    required String placeOfBirth,
    required String dateOfBirth,
    required String motherName,
    required String gender,
    required String level,
  }) async {
    final url = Uri.parse('http://202.10.36.222:3000/api/students');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('Token tidak tersedia. Silakan login kembali.');
    }

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';

    // form fields
    request.fields['nisn'] = nisn;
    request.fields['nik'] = nik;
    request.fields['name'] = name;
    request.fields['password'] = password;
    request.fields['confirmation_password'] = confirmationPassword;
    request.fields['place_of_birth'] = placeOfBirth;
    request.fields['date_of_birth'] = dateOfBirth; // format: YYYY-MM-DD
    request.fields['mother_name'] = motherName;
    request.fields['gender'] = gender;
    request.fields['level'] = level;

    // kalau ada file photo (opsional)
    // if (photoFile != null) {
    //   request.files.add(await http.MultipartFile.fromPath('photo', photoFile.path));
    // }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        print("try");
        final Map<String, dynamic> json = jsonDecode(response.body);
        return StudentSingleResponse.fromJson(json);
      } catch (e) {
        print('Gagal parsing response: $e');
        throw Exception('Gagal parsing response: $e');
      }
    } else {
      throw Exception('Gagal menambahkan data siswa: ${response.body}');
    }
  }

  /// Update student
  Future<StudentSingleResponse> updateStudent({
    required int id,
    required String nisn,
    required String nik,
    required String name,
    String? password,
    String? confirmationPassword,
    required String placeOfBirth,
    required String dateOfBirth, // format: YYYY-MM-DD
    required String motherName,
    required String gender,
    required String level,
    String? photoPath, // opsional
  }) async {
    final url = Uri.parse('http://202.10.36.222:3000/api/students/$id');

    print(url);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('Token tidak tersedia. Silakan login kembali.');
    }

    var request = http.MultipartRequest('PUT', url);
    request.headers['Authorization'] = 'Bearer $token';

    // form fields
    request.fields['nisn'] = nisn;
    request.fields['nik'] = nik;
    request.fields['name'] = name;
    request.fields['place_of_birth'] = placeOfBirth;
    request.fields['date_of_birth'] = dateOfBirth;
    request.fields['mother_name'] = motherName;
    request.fields['gender'] = gender;
    request.fields['level'] = level;

    // password hanya dikirim kalau ada input
    if (password != null &&
        confirmationPassword != null &&
        password.isNotEmpty) {
      request.fields['password'] = password;
      request.fields['confirmation_password'] = confirmationPassword;
    }

    // upload file photo opsional
    if (photoPath != null && photoPath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('photo', photoPath));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return StudentSingleResponse.fromJson(json);
      } catch (e) {
        throw Exception('Gagal parsing response update: $e');
      }
    } else {
      throw Exception('Gagal mengupdate data siswa: ${response.body}');
    }
  }

  /// Delete student
  Future<StudentResponse> deleteStudent(int id) async {
    final url = Uri.parse('http://202.10.36.222:3000/api/students/$id');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('Token tidak tersedia. Silakan login kembali.');
    }

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response.body);

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return StudentResponse.fromJson(json);
      } catch (e) {
        throw Exception('Gagal parsing response delete: $e');
      }
    } else {
      throw Exception('Gagal menghapus data peminjaman: ${response.body}');
    }
  }
}
