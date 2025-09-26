import 'package:flutter/material.dart';
import 'package:intern_libraryapp/pages/admin/student/student_detail.dart';
import 'package:intl/intl.dart';
import 'package:intern_libraryapp/models/student_response.dart';
import 'package:intern_libraryapp/services/student_service.dart';
import 'package:intern_libraryapp/tools/get_initial_name.dart';

class AdminStudentListPage extends StatefulWidget {
  const AdminStudentListPage({super.key});

  @override
  State<AdminStudentListPage> createState() => _AdminStudentListPageState();
}

class _AdminStudentListPageState extends State<AdminStudentListPage> {
  List<Student> allData = [];
  List<Student> filteredData = [];
  bool isLoading = true;

  // Filter state
  String filterName = "";
  String filterNisn = "";
  String? filterKelas;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // --- Fetch Data Siswa dari API ---
  Future<void> fetchData() async {
    try {
      final response = await StudentService().getStudents();
      setState(() {
        allData = response.data;
        filteredData = allData;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      _showSnackBar('Gagal mengambil data siswa');
    }
  }

  // --- SnackBar Helper ---
  void _showSnackBar(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  // --- Navigasi Detail ---
  void _navigateToDetail(Student student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdminStudentDetailPage(student: student),
      ),
    );
  }

  // --- Konfirmasi Hapus ---
  void _showDeleteConfirmation(Student student) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content: Text("Apakah Anda yakin ingin menghapus ${student.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await StudentService().deleteStudent(student.id);
                _showSnackBar(
                  "${student.name} berhasil dihapus",
                  success: true,
                );
                fetchData();
              } catch (e) {
                _showSnackBar("Gagal menghapus siswa");
              }
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // --- Filter Data ---
  void applyStudentFilter() {
    setState(() {
      filteredData = allData.where((student) {
        final matchName = student.name.toLowerCase().contains(
          filterName.toLowerCase(),
        );
        final matchNisn = student.nisn.contains(filterNisn);
        final matchKelas = filterKelas == null || student.level == filterKelas;
        return matchName && matchNisn && matchKelas;
      }).toList();
    });
  }

  void resetStudentFilter() {
    setState(() {
      filterName = "";
      filterNisn = "";
      filterKelas = null;
      filteredData = allData;
    });
  }

  // --- Dialog Filter ---
  Future<void> _showStudentFilterDialog() async {
    final nameController = TextEditingController(text: filterName);
    final nisnController = TextEditingController(text: filterNisn);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 25,
          right: 25,
          top: 25,
        ),
        child: StatefulBuilder(
          builder: (context, setModalState) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Filter Siswa",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Filter by Name
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Nama"),
                  ),
                  const SizedBox(height: 8),

                  // Filter by NISN
                  TextField(
                    controller: nisnController,
                    decoration: const InputDecoration(labelText: "NISN"),
                  ),
                  const SizedBox(height: 8),

                  // Filter by Kelas
                  DropdownButtonFormField<String>(
                    value: filterKelas,
                    decoration: const InputDecoration(labelText: "Kelas"),
                    items: const [
                      DropdownMenuItem(value: "X", child: Text("Kelas X")),
                      DropdownMenuItem(value: "XI", child: Text("Kelas XI")),
                      DropdownMenuItem(value: "XII", child: Text("Kelas XII")),
                    ],
                    onChanged: (value) =>
                        setModalState(() => filterKelas = value),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFed5d5e)),
                            minimumSize: const Size(double.infinity, 48),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                          onPressed: () {
                            resetStudentFilter();
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.refresh,
                            color: Color(0xFFed5d5e),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      Expanded(
                        flex: 9,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFed5d5e),
                            minimumSize: const Size(double.infinity, 48),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                          onPressed: () {
                            filterName = nameController.text;
                            filterNisn = nisnController.text;
                            applyStudentFilter();
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Terapkan Filter",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // --- Widget Builder ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Siswa"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showStudentFilterDialog(),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFed5d5e)),
            )
          : filteredData.isEmpty
          ? const Center(child: Text("Tidak ada data siswa"))
          : RefreshIndicator(
              color: Color(0xFFed5d5e),
              onRefresh: fetchData,
              child: ListView.builder(
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  final student = filteredData[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          'https://ui-avatars.com/api/?name=${Uri.encodeComponent(getInitials(student.name))}',
                        ),
                      ),
                      title: Text(student.name),
                      subtitle: Text("NISN: ${student.nisn}"),
                      onTap: () => _navigateToDetail(student),
                      trailing: PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (value) {
                          if (value == 'edit') {
                            showStudentDialog(
                              context,
                              parentContext: this.context,
                              item: student,
                              onSuccess: fetchData,
                            );
                          } else if (value == 'delete') {
                            _showDeleteConfirmation(student);
                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(value: 'edit', child: Text('Edit')),
                          PopupMenuItem(value: 'delete', child: Text('Hapus')),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFed5d5e),
        onPressed: () => showStudentDialog(
          context,
          parentContext: this.context,
          onSuccess: fetchData,
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// --- Dialog Tambah/Edit Siswa ---
// --- Dialog Tambah/Edit Siswa ---
Future<void> showStudentDialog(
  BuildContext context, {
  required BuildContext parentContext,
  Student? item,
  required VoidCallback onSuccess, // 🔥 tambahkan callback
}) async {
  final nisnController = TextEditingController(text: item?.nisn);
  final nikController = TextEditingController(text: item?.nik);
  final nameController = TextEditingController(text: item?.name);
  final passwordController = TextEditingController();
  final placeController = TextEditingController(text: item?.placeOfBirth);
  DateTime? dateOfBirth = item?.dateOfBirth;
  final motherController = TextEditingController(text: item?.motherName);
  String? gender = item?.gender;
  String? level = item?.level;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (modalCtx) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(modalCtx).viewInsets.bottom,
        left: 25,
        right: 25,
        top: 25,
      ),
      child: StatefulBuilder(
        builder: (context, setModalState) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item == null ? "Tambah Siswa" : "Edit Siswa",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // NISN
                TextField(
                  controller: nisnController,
                  decoration: const InputDecoration(labelText: "NISN"),
                ),
                const SizedBox(height: 8),

                // NIK
                TextField(
                  controller: nikController,
                  decoration: const InputDecoration(labelText: "NIK"),
                ),
                const SizedBox(height: 8),

                // Nama
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Nama"),
                ),
                const SizedBox(height: 8),

                // Password
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                ),
                const SizedBox(height: 8),

                // Tempat Lahir
                TextField(
                  controller: placeController,
                  decoration: const InputDecoration(labelText: "Tempat Lahir"),
                ),
                const SizedBox(height: 8),

                // Tanggal Lahir
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: dateOfBirth ?? DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setModalState(() => dateOfBirth = picked);
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: "Tanggal Lahir",
                    ),
                    child: Text(
                      dateOfBirth == null
                          ? "-"
                          : DateFormat('dd MMM yyyy').format(dateOfBirth!),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Nama Ibu
                TextField(
                  controller: motherController,
                  decoration: const InputDecoration(labelText: "Nama Ibu"),
                ),
                const SizedBox(height: 8),

                // Gender
                DropdownButtonFormField<String>(
                  value: gender,
                  decoration: const InputDecoration(labelText: "Jenis Kelamin"),
                  items: const [
                    DropdownMenuItem(value: "M", child: Text("Laki-laki")),
                    DropdownMenuItem(value: "F", child: Text("Perempuan")),
                  ],
                  onChanged: (val) => setModalState(() => gender = val),
                ),
                const SizedBox(height: 8),

                // Level
                DropdownButtonFormField<String>(
                  value: level,
                  decoration: const InputDecoration(labelText: "Kelas"),
                  items: const [
                    DropdownMenuItem(value: "X", child: Text("X")),
                    DropdownMenuItem(value: "XI", child: Text("XI")),
                    DropdownMenuItem(value: "XII", child: Text("XII")),
                  ],
                  onChanged: (val) => setModalState(() => level = val),
                ),
                const SizedBox(height: 16),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFed5d5e),
                    minimumSize: const Size(double.infinity, 48),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  onPressed: () async {
                    if (nisnController.text.isEmpty ||
                        nameController.text.isEmpty ||
                        placeController.text.isEmpty ||
                        dateOfBirth == null ||
                        gender == null ||
                        level == null) {
                      Navigator.pop(context); // tutup modal
                      Future.delayed(const Duration(milliseconds: 200), () {
                        ScaffoldMessenger.of(parentContext).showSnackBar(
                          const SnackBar(
                            content: Text("Lengkapi semua data wajib"),
                          ),
                        );
                      });
                      return;
                    }

                    try {
                      if (item == null) {
                        await StudentService().createStudent(
                          nisn: nisnController.text,
                          nik: nikController.text,
                          name: nameController.text,
                          password: passwordController.text,
                          confirmationPassword: passwordController.text,
                          placeOfBirth: placeController.text,
                          dateOfBirth: DateFormat(
                            'yyyy-MM-dd',
                          ).format(dateOfBirth!),
                          motherName: motherController.text,
                          gender: gender!,
                          level: level!,
                        );
                      } else {
                        await StudentService().updateStudent(
                          id: item.id,
                          nisn: nisnController.text,
                          nik: nikController.text,
                          name: nameController.text,
                          password: passwordController.text,
                          confirmationPassword: passwordController.text,
                          placeOfBirth: placeController.text,
                          dateOfBirth: DateFormat(
                            'yyyy-MM-dd',
                          ).format(dateOfBirth!),
                          motherName: motherController.text,
                          gender: gender!,
                          level: level!,
                        );
                      }

                      onSuccess(); // 🔥 panggil fetchData
                      Navigator.pop(context); // tutup modal
                      Future.delayed(const Duration(milliseconds: 200), () {
                        ScaffoldMessenger.of(parentContext).showSnackBar(
                          SnackBar(
                            content: Text(
                              item == null
                                  ? "Berhasil menambahkan siswa!"
                                  : "Berhasil memperbarui siswa!",
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      });
                    } catch (e) {
                      Navigator.pop(
                        context,
                      ); // tetap tutup modal walaupun gagal
                      Future.delayed(const Duration(milliseconds: 200), () {
                        ScaffoldMessenger.of(parentContext).showSnackBar(
                          SnackBar(
                            content: Text("Gagal: $e"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      });
                    }
                  },
                  child: const Text(
                    "Simpan",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    ),
  );
}

// --- Detail Page ---
// class StudentDetailPage extends StatelessWidget {
//   final Student student;
//   const StudentDetailPage({super.key, required this.student});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(student.name)),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             CircleAvatar(
//               radius: 40,
//               backgroundImage: NetworkImage(
//                 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(getInitials(student.name))}',
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               student.name,
//               style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Text("NISN: ${student.nisn}", style: const TextStyle(fontSize: 18)),
//             const SizedBox(height: 10),
//             Text(
//               "Kelas: ${student.level}",
//               style: const TextStyle(fontSize: 18),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
