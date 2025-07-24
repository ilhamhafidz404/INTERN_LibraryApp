import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = '';
  String userNISN = '';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      userName = prefs.getString('name') ?? 'Tidak Diketahui';
      userNISN = prefs.getString('username') ?? '-';
    });
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
      appBar: AppBar(title: const Text('Profil Saya'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 24),
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                'https://ui-avatars.com/api/?name=${Uri.encodeComponent(getInitials(userName))}',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              userName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('NISN: $userNISN', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Ganti Profil'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.pushNamed(context, '/edit-profile'),
            ),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('Ubah Password'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.pushNamed(context, '/change-password'),
            ),
          ],
        ),
      ),
    );
  }
}
