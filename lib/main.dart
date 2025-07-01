import 'package:flutter/material.dart';
import 'package:intern_libraryapp/main_page.dart';
import 'pages/login_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const LoginPage(),
      routes: {'/home': (context) => const MainPage()},
    );
  }
}
