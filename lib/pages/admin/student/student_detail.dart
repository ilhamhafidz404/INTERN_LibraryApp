import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intern_libraryapp/models/student_response.dart';
import 'package:intern_libraryapp/tools/get_initial_name.dart';

class AdminStudentDetailPage extends StatelessWidget {
  final Student student;
  const AdminStudentDetailPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(student.name),
        // backgroundColor: const Color(0xFFed5d5e),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // --- Avatar + Nama ---
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    'https://ui-avatars.com/api/?name=${Uri.encodeComponent(getInitials(student.name))}',
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  student.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Kelas: ${student.level ?? "-"}",
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // --- Detail Info ---
          buildInfoCard(Icons.badge, "NISN", student.nisn),
          buildInfoCard(Icons.assignment_ind, "NIK", student.nik ?? "-"),
          buildInfoCard(
            Icons.location_city,
            "Tempat Lahir",
            student.placeOfBirth ?? "-",
          ),
          buildInfoCard(
            Icons.calendar_today,
            "Tanggal Lahir",
            student.dateOfBirth != null
                ? DateFormat('dd MMMM yyyy').format(student.dateOfBirth!)
                : "-",
          ),
          buildInfoCard(
            Icons.family_restroom,
            "Nama Ibu",
            student.motherName ?? "-",
          ),
          buildInfoCard(
            Icons.male,
            "Jenis Kelamin",
            student.gender == "M" ? "Laki-laki" : "Perempuan",
          ),
        ],
      ),
    );
  }

  Widget buildInfoCard(IconData icon, String title, String value) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFed5d5e)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }
}
