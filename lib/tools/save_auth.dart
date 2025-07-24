import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveAuth(String token, String name, String username) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
  await prefs.setString('name', name);
  await prefs.setString('username', username);
}
