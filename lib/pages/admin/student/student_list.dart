import 'package:flutter/material.dart';
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

  // filter state
  String filterName = "";
  String filterNisn = "";
  String? filterKelas;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengambil data siswa')),
      );
    }
  }

  void showEditStudentDialog(Student student) {
    // TODO: implementasi form edit siswa
  }

  void showDeleteConfirmation(Student student) {
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
              // TODO: panggil StudentService().deleteStudent(student.id)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${student.name} berhasil dihapus")),
              );
              fetchData();
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(Student student) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => StudentDetailPage(student: student)),
    );
  }

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

  Future<void> showStudentFilterDialog() async {
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
                    decoration: const InputDecoration(
                      labelText: "Nama",
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),

                  // Filter by NISN
                  TextField(
                    controller: nisnController,
                    decoration: const InputDecoration(
                      labelText: "NISN",
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),

                  // Filter by Kelas
                  DropdownButtonFormField<String>(
                    value: filterKelas,
                    decoration: const InputDecoration(
                      labelText: "Kelas",
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: "X", child: Text("Kelas X")),
                      DropdownMenuItem(value: "XI", child: Text("Kelas XI")),
                      DropdownMenuItem(value: "XII", child: Text("Kelas XII")),
                    ],
                    onChanged: (value) =>
                        setModalState(() => filterKelas = value),
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  const SizedBox(height: 16),

                  // Apply Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFed5d5e),
                      minimumSize: const Size(double.infinity, 48),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
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
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Reset Button
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFFed5d5e),
                        width: 1.5,
                      ),
                      minimumSize: const Size(double.infinity, 48),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    onPressed: () {
                      resetStudentFilter();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Reset",
                      style: TextStyle(color: Color(0xFFed5d5e), fontSize: 14),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Siswa"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => showStudentFilterDialog(),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredData.isEmpty
          ? const Center(child: Text("Tidak ada data siswa"))
          : RefreshIndicator(
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
                        icon: const Icon(
                          Icons.more_vert,
                          color: Color.fromARGB(82, 0, 0, 0),
                        ),
                        onSelected: (value) {
                          if (value == 'edit') {
                            showEditStudentDialog(student);
                          } else if (value == 'delete') {
                            showDeleteConfirmation(student);
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return const [
                            PopupMenuItem(value: 'edit', child: Text('Edit')),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Hapus'),
                            ),
                          ];
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFed5d5e),
        onPressed: () {
          // TODO: Navigasi ke tambah siswa
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class StudentDetailPage extends StatelessWidget {
  final Student student;
  const StudentDetailPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(student.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                'https://ui-avatars.com/api/?name=${Uri.encodeComponent(getInitials(student.name))}',
              ),
            ),
            const SizedBox(height: 20),
            Text(
              student.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("NISN: ${student.nisn}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text(
              "Kelas: ${student.level}",
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
