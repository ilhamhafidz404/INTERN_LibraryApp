import 'package:flutter/material.dart';
import 'package:intern_libraryapp/models/admin_response.dart';
import 'package:intern_libraryapp/services/admin_service.dart';
import 'package:intern_libraryapp/tools/get_initial_name.dart';

class SuperAdminListAdminPage extends StatefulWidget {
  const SuperAdminListAdminPage({super.key});

  @override
  State<SuperAdminListAdminPage> createState() =>
      _SuperAdminListAdminPageState();
}

class _SuperAdminListAdminPageState extends State<SuperAdminListAdminPage> {
  List<Admin> allData = [];
  List<Admin> filteredData = [];
  bool isLoading = true;

  String filter = "";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // --- Ambil data admin dari API ---
  Future<void> fetchData() async {
    try {
      final response = await AdminService().getAdmins();
      setState(() {
        allData = response.data;
        filteredData = allData;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      _showSnackBar('Gagal mengambil data admin');
    }
  }

  void _showSnackBar(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  // --- Konfirmasi hapus admin ---
  void _showDeleteConfirmation(Admin admin) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content: Text("Apakah Anda yakin ingin menghapus ${admin.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await AdminService().deleteAdmin(admin.id);
                _showSnackBar("${admin.name} berhasil dihapus", success: true);
                fetchData();
              } catch (e) {
                _showSnackBar("Gagal menghapus admin");
              }
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // --- Filter ---
  void applyFilter() {
    setState(() {
      filteredData = allData.where((admin) {
        final matchName = admin.name.toLowerCase().contains(
          filter.toLowerCase(),
        );
        final matchUsername = admin.username.toLowerCase().contains(
          filter.toLowerCase(),
        );
        return matchName && matchUsername;
      }).toList();
    });
  }

  void resetFilter() {
    setState(() {
      filter = "";
      filteredData = allData;
    });
  }

  Future<void> _showFilterDialog() async {
    final filterController = TextEditingController(text: filter);

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
                    "Filter Admin",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Filter
                  TextField(
                    controller: filterController,
                    decoration: const InputDecoration(labelText: "Nama"),
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
                            resetFilter();
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
                            filter = filterController.text;
                            applyFilter();
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

  // --- UI ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Admin"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFed5d5e)),
            )
          : filteredData.isEmpty
          ? const Center(child: Text("Tidak ada data admin"))
          : RefreshIndicator(
              color: Color(0xFFed5d5e),
              onRefresh: fetchData,
              child: ListView.builder(
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  final admin = filteredData[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          'https://ui-avatars.com/api/?name=${Uri.encodeComponent(getInitials(admin.name))}',
                        ),
                      ),
                      title: Text(admin.name),
                      subtitle: Text("Username: ${admin.username}"),
                      trailing: PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (value) {
                          if (value == 'edit') {
                            showAdminDialog(
                              context,
                              parentContext: this.context,
                              item: admin,
                              onSuccess: fetchData,
                            );
                          } else if (value == 'delete') {
                            _showDeleteConfirmation(admin);
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
        onPressed: () => showAdminDialog(
          context,
          parentContext: this.context,
          onSuccess: fetchData,
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// --- Dialog Tambah/Edit Admin ---
Future<void> showAdminDialog(
  BuildContext context, {
  required BuildContext parentContext,
  Admin? item,
  required VoidCallback onSuccess,
}) async {
  final nameController = TextEditingController(text: item?.name);
  final usernameController = TextEditingController(text: item?.username);
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

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
                  item == null ? "Tambah Admin" : "Edit Admin",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Nama
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Nama"),
                ),
                const SizedBox(height: 8),

                // Username
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: "Username"),
                ),
                const SizedBox(height: 8),

                // Password
                TextField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setModalState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Confirm Password
                TextField(
                  controller: confirmPasswordController,
                  obscureText: obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setModalState(() {
                          obscureConfirmPassword = !obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
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
                    if (nameController.text.isEmpty ||
                        usernameController.text.isEmpty ||
                        (item == null && passwordController.text.isEmpty) ||
                        (item == null &&
                            confirmPasswordController.text.isEmpty)) {
                      Navigator.pop(context);
                      Future.delayed(const Duration(milliseconds: 200), () {
                        ScaffoldMessenger.of(parentContext).showSnackBar(
                          const SnackBar(
                            content: Text("Lengkapi semua data wajib"),
                          ),
                        );
                      });
                      return;
                    }

                    if (passwordController.text.isNotEmpty &&
                        passwordController.text !=
                            confirmPasswordController.text) {
                      Navigator.pop(context);
                      Future.delayed(const Duration(milliseconds: 200), () {
                        ScaffoldMessenger.of(parentContext).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Password dan Confirm Password tidak sama",
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      });
                      return;
                    }

                    try {
                      if (item == null) {
                        await AdminService().createAdmin(
                          name: nameController.text,
                          username: usernameController.text,
                          password: passwordController.text,
                          confirmationPassword: confirmPasswordController.text,
                        );
                      } else {
                        await AdminService().updateAdmin(
                          id: item.id,
                          name: nameController.text,
                          username: usernameController.text,
                          password: passwordController.text.isNotEmpty
                              ? passwordController.text
                              : null, // hanya update password kalau diisi
                        );
                      }

                      onSuccess();
                      Navigator.pop(context);
                      Future.delayed(const Duration(milliseconds: 200), () {
                        ScaffoldMessenger.of(parentContext).showSnackBar(
                          SnackBar(
                            content: Text(
                              item == null
                                  ? "Berhasil menambahkan admin!"
                                  : "Berhasil memperbarui admin!",
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      });
                    } catch (e) {
                      Navigator.pop(context);
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
