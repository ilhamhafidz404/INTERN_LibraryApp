import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intern_libraryapp/models/login_response.dart';

class AuthService {
  Future<LoginResponse> login(String username, String password) async {
    final url = Uri.parse('http://localhost:3000/api/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return LoginResponse.fromJson(data);
    } else {
      // lempar error agar bisa ditangkap di UI
      throw Exception('Login gagal: ${response.body}');
    }
  }
}
