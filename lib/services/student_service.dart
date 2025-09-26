import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intern_libraryapp/models/student_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentService {
  Future<StudentResponse> getStudents() async {
    final url = Uri.parse('http://192.168.49.246:3000/api/students');

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
        // langsung parse ke StudentResponse
        return StudentResponse.fromJson(jsonData);
      } catch (e) {
        throw Exception('Gagal parsing response: $e');
      }
    } else {
      throw Exception('Gagal mengambil data siswa: ${response.body}');
    }
  }
}
