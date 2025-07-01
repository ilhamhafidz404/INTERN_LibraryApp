import 'package:flutter/material.dart';
import 'package:intern_libraryapp/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // services
  final auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Image.asset(
              'images/login_bg.jpg',
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.4,
              fit: BoxFit.cover,
            ),

            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black],
                ),
              ),
            ),

            Positioned(
              top: MediaQuery.of(context).size.height * 0.15,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat Datang',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black45,
                          blurRadius: 4,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5), // Jarak antar teks
                  Text(
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. '
                    'Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      height: 1.5,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Center(
                      child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(20),
                        children: [
                          TextFormField(
                            controller: _usernameController,
                            cursorColor: Colors.black87,
                            decoration: const InputDecoration(
                              labelText: 'Username',
                              floatingLabelStyle: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(
                                Icons.person_outlined,
                                color: Color(0xFFed5d5e),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFe9e9e9),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black38,
                                  width: 1,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 2,
                                ),
                              ),
                            ),

                            validator: (value) =>
                                (value == null || value.isEmpty)
                                ? 'Username wajib diisi'
                                : null,
                          ),

                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _passwordController,
                            cursorColor: Colors.black87,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              floatingLabelStyle: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(
                                Icons.lock_outlined,
                                color: Color(0xFFed5d5e),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFe9e9e9),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black38,
                                  width: 1,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 2,
                                ),
                              ),
                            ),
                            obscureText: true,
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                ? 'Password wajib diisi'
                                : null,
                          ),

                          const SizedBox(height: 24),

                          ElevatedButton(
                            onPressed: () async {
                              try {
                                await AuthService().login(
                                  _usernameController.text,
                                  _passwordController.text,
                                );

                                Navigator.pushReplacementNamed(
                                  context,
                                  '/home',
                                );
                              } catch (e) {
                                print('Login gagal: $e');
                              }
                            },
                            child: const Text('Masuk'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFed5d5e),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          const SizedBox(height: 100),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '“',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Times New Roman',
                                  height: 0.5,
                                ),
                              ),
                              Text(
                                'Baca bukumu, jangan biarkan sampai berdebu!',
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Georgia',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
