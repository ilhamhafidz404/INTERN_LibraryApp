import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intern_libraryapp/models/admin_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminService {
  final String baseUrl = "http://192.168.49.246:3000/api";

  /// GET all admins
  Future<AdminResponse> getAdmins() async {
    final url = Uri.parse('$baseUrl/admins');
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
        return AdminResponse.fromJson(jsonData);
      } catch (e) {
        throw Exception('Gagal parsing response: $e');
      }
    } else {
      throw Exception('Gagal mengambil data admin: ${response.body}');
    }
  }

  /// CREATE admin
  Future<AdminSingleResponse> createAdmin({
    required String name,
    required String username,
    required String password,
    required String confirmationPassword,
    String level = "admin", // default level = admin
  }) async {
    final url = Uri.parse('$baseUrl/admins');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('Token tidak tersedia. Silakan login kembali.');
    }

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['name'] = name;
    request.fields['username'] = username;
    request.fields['password'] = password;
    request.fields['confirmation_password'] = confirmationPassword;
    request.fields['level'] = level;

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return AdminSingleResponse.fromJson(json);
      } catch (e) {
        throw Exception('Gagal parsing response: $e');
      }
    } else {
      throw Exception('Gagal menambahkan admin: ${response.body}');
    }
  }

  /// UPDATE admin
  Future<AdminSingleResponse> updateAdmin({
    required int id,
    required String name,
    required String username,
    String? password,
    String? confirmationPassword,
    String? level,
  }) async {
    final url = Uri.parse('$baseUrl/admins/$id');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('Token tidak tersedia. Silakan login kembali.');
    }

    var request = http.MultipartRequest('PUT', url);
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['name'] = name;
    request.fields['username'] = username;

    if (password != null && password.isNotEmpty) {
      request.fields['password'] = password;
      request.fields['confirmation_password'] = confirmationPassword ?? '';
    }

    if (level != null && level.isNotEmpty) {
      request.fields['level'] = level;
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return AdminSingleResponse.fromJson(json);
      } catch (e) {
        throw Exception('Gagal parsing response update: $e');
      }
    } else {
      throw Exception('Gagal mengupdate admin: ${response.body}');
    }
  }

  /// DELETE admin
  Future<AdminResponse> deleteAdmin(int id) async {
    final url = Uri.parse('$baseUrl/admins/$id');
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

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return AdminResponse.fromJson(json);
      } catch (e) {
        throw Exception('Gagal parsing response delete: $e');
      }
    } else {
      throw Exception('Gagal menghapus admin: ${response.body}');
    }
  }
}
