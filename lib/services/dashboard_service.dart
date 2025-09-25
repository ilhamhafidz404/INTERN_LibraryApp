import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intern_libraryapp/models/dashboard_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardService {
  static const String baseUrl = 'http://192.168.49.246:3000/api';

  Future<DashboardResponse> getDashboard() async {
    print("test");

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/dashboard'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        print("Dashboard response: ${response.body}");

        return DashboardResponse.fromJson(json);
      } else {
        throw Exception(
          'Gagal mengambil data dashboard (Status: ${response.statusCode}): ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil data dashboard: $e');
    }
  }
}
