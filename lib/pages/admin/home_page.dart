import 'package:flutter/material.dart';
import 'package:intern_libraryapp/models/dashboard_response.dart';
import 'package:intern_libraryapp/pages/admin/book/list_book_page.dart';
import 'package:intern_libraryapp/pages/login_page.dart';
import 'package:intern_libraryapp/services/dashboard_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  String adminName = '';
  late Dashboard dashboard = Dashboard(
    totalBook: 0,
    totalAdmin: 0,
    totalStudent: 0,
  );

  @override
  void initState() {
    super.initState();
    loadUserData();
    fetchDashboard();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      adminName = prefs.getString('name') ?? 'Tidak Diketahui';
    });
  }

  Future<void> fetchDashboard() async {
    try {
      final response = await DashboardService().getDashboard();
      setState(() {
        dashboard = response.data;
      });
    } catch (e) {
      print('Gagal mengambil dashboard: $e');
    }
  }

  String getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));

    if (parts.length == 1) {
      final word = parts[0];
      final firstTwo = word.length >= 2
          ? word.substring(0, 2).toUpperCase()
          : word.toUpperCase(); // kalau cuma 1 huruf
      return firstTwo.split('').join(' ');
    } else {
      final initials = parts.map((part) => part[0].toUpperCase()).join(' ');
      return initials;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CMS Library App'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 24),
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                  'https://ui-avatars.com/api/?name=${Uri.encodeComponent(getInitials(adminName))}',
                ),
                backgroundColor: Color.fromARGB(202, 237, 93, 93),
              ),
              const SizedBox(height: 16),
              Text(
                adminName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Color(0xFFed5d5e),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Total Admin",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            dashboard.totalAdmin.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 25),
                      Column(
                        children: [
                          Text(
                            "Total Siswa",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            dashboard.totalStudent.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 25),
                      Column(
                        children: [
                          Text(
                            "Total Buku",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            dashboard.totalBook.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.book),
                title: const Text('Kelola Buku'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                // onTap: () => Navigator.pushNamed(context, '/edit-profile'),
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AdminBookListPage()),
                  ),
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Konfirmasi Logout'),
                      content: Text(
                        'Apakah Anda yakin ingin keluar dari akun?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(context), // tutup dialog
                          child: Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.clear(); // hapus semua data lokal

                            // tutup dialog lalu pindah ke login page
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => LoginPage()),
                              (route) => false,
                            );
                          },
                          child: Text(
                            'Logout',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
