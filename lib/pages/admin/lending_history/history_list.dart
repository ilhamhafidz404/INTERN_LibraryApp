import 'package:flutter/material.dart';
import 'package:intern_libraryapp/models/book_response.dart';
import 'package:intern_libraryapp/models/student_response.dart';
import 'package:intern_libraryapp/services/student_service.dart';
import 'package:intl/intl.dart';
import 'package:intern_libraryapp/models/lending_history_response.dart';
import 'package:intern_libraryapp/services/lending_history_service.dart';
// tambahkan service siswa dan buku
// import 'package:intern_libraryapp/services/student_service.dart';
import 'package:intern_libraryapp/services/book_service.dart';

class AdminLendingHistoryListPage extends StatefulWidget {
  @override
  _AdminLendingHistoryListPageState createState() =>
      _AdminLendingHistoryListPageState();
}

class _AdminLendingHistoryListPageState
    extends State<AdminLendingHistoryListPage> {
  List<LendingHistory> allData = [];
  List<LendingHistory> filteredData = [];
  bool isLoading = true;

  // filter fields
  String? filterBook;
  String? filterStudent;
  DateTime? filterStartDate;
  DateTime? filterEndDate;
  String? filterStatus;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await LendingHistoryService().getHistories();
      setState(() {
        allData = response.data;
        filteredData = allData;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data peminjaman')),
      );
    }
  }

  void applyFilter() {
    setState(() {
      filteredData = allData.where((item) {
        final matchBook =
            filterBook == null ||
            filterBook!.isEmpty ||
            item.bookTitle.toLowerCase().contains(filterBook!.toLowerCase());

        final matchStudent =
            filterStudent == null ||
            filterStudent!.isEmpty ||
            item.studentName.toLowerCase().contains(
              filterStudent!.toLowerCase(),
            );

        final matchStatus =
            filterStatus == null ||
            filterStatus!.isEmpty ||
            (filterStatus == "Dipinjam" && item.status == "loaned") ||
            (filterStatus == "Dikembalikan" && item.status == "returned") ||
            (filterStatus == "Telat Pengembalian" &&
                item.status == "late returned");

        final matchStartDate =
            filterStartDate == null ||
            item.startDate.isAfter(filterStartDate!) ||
            item.startDate.isAtSameMomentAs(filterStartDate!);

        final matchEndDate =
            filterEndDate == null ||
            item.endDate.isBefore(filterEndDate!) ||
            item.endDate.isAtSameMomentAs(filterEndDate!);

        return matchBook &&
            matchStudent &&
            matchStatus &&
            matchStartDate &&
            matchEndDate;
      }).toList();
    });
  }

  void resetFilter() {
    setState(() {
      filterBook = "";
      filterStudent = "";
      filterStartDate = null;
      filterEndDate = null;
      filterStatus = null;
    });

    applyFilter();
  }

  Widget buildLendingCard(LendingHistory item) {
    final formatter = DateFormat('dd MMM yyyy');

    String statusText;
    Color statusColor;
    switch (item.status) {
      case 'loaned':
        statusText = 'Dipinjam';
        statusColor = Colors.orange;
        break;
      case 'returned':
        statusText = 'Dikembalikan';
        statusColor = Colors.green;
        break;
      case 'late returned':
        statusText = 'Telat Pengembalian';
        statusColor = Colors.red;
        break;
      default:
        statusText = item.status;
        statusColor = Colors.grey;
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.bookTitle,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text('Penulis: ${item.bookAuthor}'),
                  SizedBox(height: 4),
                  Text('Siswa: ${item.studentName}'),
                  SizedBox(height: 4),
                  Text(
                    'Tanggal Pinjam: ${formatter.format(item.startDate)} - ${formatter.format(item.endDate)}',
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text('Status: '),
                      Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showAddLendingDialog() async {
    String? selectedStudent;
    String? selectedBook;
    DateTime? startDate;
    DateTime? endDate;

    List<Student> students = [];
    List<Book> books = [];

    // ambil data dari API
    try {
      final studentResponse = await StudentService().getStudents();
      setState(() {
        students = studentResponse.data;
      });

      final bookResponse = await BookService().getBooks();
      setState(() {
        books = bookResponse.data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data siswa/buku')),
      );
    }

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
                    "Tambah Data Peminjaman",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Pilih Siswa
                  DropdownButtonFormField<String>(
                    value: selectedStudent,
                    decoration: const InputDecoration(
                      labelText: "Pilih Siswa",
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                    ),
                    items: students.map((s) {
                      return DropdownMenuItem(
                        value: s.id.toString(),
                        child: Text("${s.name} - ${s.nisn}"),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setModalState(() => selectedStudent = value),
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),

                  const SizedBox(height: 8),

                  // Pilih Buku
                  DropdownButtonFormField<String>(
                    value: selectedBook,
                    decoration: const InputDecoration(
                      labelText: "Pilih Buku",
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                    ),
                    items: books.map((s) {
                      return DropdownMenuItem(
                        value: s.id.toString(),
                        child: Text(s.title),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setModalState(() => selectedBook = value),
                  ),
                  const SizedBox(height: 8),

                  // Tanggal Pinjam
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: startDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setModalState(() => startDate = picked);
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: "Tanggal Pinjam",
                      ),
                      child: Text(
                        startDate == null
                            ? "-"
                            : DateFormat('dd MMM yyyy').format(startDate!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Tanggal Pengembalian
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: endDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setModalState(() => endDate = picked);
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: "Tanggal Pengembalian",
                      ),
                      child: Text(
                        endDate == null
                            ? "-"
                            : DateFormat('dd MMM yyyy').format(endDate!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFed5d5e),
                      minimumSize: const Size(double.infinity, 48),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    onPressed: () async {
                      if (selectedStudent == null ||
                          selectedBook == null ||
                          startDate == null ||
                          endDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Lengkapi semua data")),
                        );
                        return;
                      }

                      try {
                        // Panggil API tambah peminjaman
                        final _ = await LendingHistoryService().postHistory(
                          studentId: int.parse(selectedStudent!),
                          bookId: int.parse(selectedBook!),
                          startDate: DateFormat(
                            'yyyy-MM-dd',
                          ).format(startDate!),
                          endDate: DateFormat('yyyy-MM-dd').format(endDate!),
                        );

                        // Jika berhasil
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Berhasil menambahkan data!"),
                            backgroundColor: Colors.green,
                          ),
                        );

                        Navigator.pop(context);
                        fetchData();
                      } catch (e) {
                        // Jika gagal
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Gagal menambahkan data: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "Simpan",
                      style: TextStyle(color: Colors.white, fontSize: 14),
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

  Future<void> showFilterDialog() async {
    final bookController = TextEditingController(text: filterBook);
    final studentController = TextEditingController(text: filterStudent);

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
                    "Filter Data",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Nama Buku
                  TextField(
                    controller: bookController,
                    decoration: const InputDecoration(
                      labelText: "Nama Buku",
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),

                  // Nama Siswa
                  TextField(
                    controller: studentController,
                    decoration: const InputDecoration(
                      labelText: "Nama Siswa",
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),

                  // Date pickers
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: filterStartDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setModalState(() => filterStartDate = picked);
                            }
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: "Tanggal Mulai",
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 12,
                              ),
                            ),
                            child: Text(
                              filterStartDate == null
                                  ? "-"
                                  : DateFormat(
                                      'dd MMM yyyy',
                                    ).format(filterStartDate!),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: filterEndDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setModalState(() => filterEndDate = picked);
                            }
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: "Tanggal Akhir",
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 12,
                              ),
                            ),
                            child: Text(
                              filterEndDate == null
                                  ? "-"
                                  : DateFormat(
                                      'dd MMM yyyy',
                                    ).format(filterEndDate!),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Status dropdown
                  DropdownButtonFormField<String>(
                    value: filterStatus,
                    decoration: const InputDecoration(
                      labelText: "Status",
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "Dipinjam",
                        child: Text(
                          "Dipinjam",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "Dikembalikan",
                        child: Text(
                          "Dikembalikan",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "Telat Pengembalian",
                        child: Text(
                          "Telat Pengembalian",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                    onChanged: (value) =>
                        setModalState(() => filterStatus = value),
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  const SizedBox(height: 16),

                  // Buttons: apply + reset (stacked)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFed5d5e),
                      minimumSize: const Size(double.infinity, 48),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    onPressed: () {
                      // simpan nilai dari controller ke state parent
                      filterBook = bookController.text;
                      filterStudent = studentController.text;
                      applyFilter();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Terapkan Filter",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 8),
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
                      resetFilter();
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
        title: Text('Data Peminjaman'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => showFilterDialog(),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : filteredData.isEmpty
          ? Center(child: Text("Tidak ada data"))
          : ListView(
              padding: const EdgeInsets.only(top: 16, bottom: 30),
              children: filteredData.map(buildLendingCard).toList(),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFed5d5e),
        onPressed: () => showAddLendingDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
