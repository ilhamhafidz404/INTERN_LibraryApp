import 'package:intern_libraryapp/models/login_user.dart';

class LoginData {
  final String token;
  final LoginUser user;

  LoginData({required this.token, required this.user});

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      token: json['token'],
      user: LoginUser.fromJson(json['user']),
    );
  }
}
