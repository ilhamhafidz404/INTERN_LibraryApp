import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intern_libraryapp/models/login_response.dart';

class AuthService {
  Future<LoginResponse> login(String username, String password) async {
    // final url = Uri.parse('http://localhost:3000/api/login');
    final url = Uri.parse('http://192.168.49.246:3000/api/login');
    // final url = Uri.parse('http://10.1.19.2:3000/api/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    print(response.body);

    if (response.statusCode == 200) {
      try {
        final json = jsonDecode(response.body);

        return LoginResponse.fromJson(json);
      } catch (e) {
        throw Exception('Gagal parsing response: $e');
      }
    } else {
      throw Exception('Login gagal: ${response.body}');
    }
  }
}
