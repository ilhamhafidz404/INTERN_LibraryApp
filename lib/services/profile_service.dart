import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intern_libraryapp/models/profile_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  Future<ProfileResponse> showProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final studentId = prefs.getInt('id');
    final token = prefs.getString('token');

    if (studentId == null) {
      throw Exception('Student ID not found in SharedPreferences');
    }

    final url = Uri.parse('http://192.168.49.246:3000/api/profile/$studentId');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      try {
        final json = jsonDecode(response.body);
        return ProfileResponse.fromJson(json);
      } catch (e) {
        throw Exception('Gagal parsing response: $e');
      }
    } else {
      throw Exception('Gagal mendapatkan profile: ${response.body}');
    }
  }

  Future<void> updateProfile({
    required String name,
    required String nik,
    required String nisn,
    required String placeOfBirth,
    required String dateOfBirth,
    required String motherName,
    required String gender,
    required String level,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final studentId = prefs.getInt('id');
    final token = prefs.getString('token');

    if (studentId == null || token == null) {
      throw Exception('ID atau token tidak ditemukan di SharedPreferences');
    }

    final url = Uri.parse('http://192.168.49.246:3000/api/profile/$studentId');

    final body = jsonEncode({
      "name": name,
      "nik": nik,
      "nisn": nisn,
      "place_of_birth": placeOfBirth,
      "date_of_birth": dateOfBirth,
      "mother_name": motherName,
      "gender": gender,
      "level": level,
    });

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      // Update berhasil
      print("Update profile berhasil");
    } else {
      // Gagal update
      throw Exception('Gagal update profile: ${response.body}');
    }
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmationNewPassword,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final studentId = prefs.getInt('id');
    final token = prefs.getString('token');

    if (studentId == null || token == null) {
      throw Exception('ID atau token tidak ditemukan di SharedPreferences');
    }

    final url = Uri.parse(
      'http://192.168.49.246:3000/api/profile/change-password/$studentId',
    );

    final body = jsonEncode({
      "old_password": oldPassword,
      "new_password": newPassword,
      "confirmation_new_password": confirmationNewPassword,
    });

    print(body);

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      print("Password berhasil diubah");
    } else {
      throw Exception('Gagal ubah password: ${response.body}');
    }
  }
}
