import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intern_libraryapp/models/lending_history_response.dart';
import 'package:intern_libraryapp/services/lending_history_service.dart';

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

                  // Input Nama Buku
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

                  // Input Nama Siswa
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

                  // Date Pickers
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

                  // Dropdown Status
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
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ), // teks hasil pilihan juga hitam
                  ),
                  const SizedBox(height: 16),

                  // Tombol Apply Filter
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFed5d5e),
                      minimumSize: const Size(double.infinity, 48),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // tanpa rounded
                      ),
                    ),
                    onPressed: () {
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
                      ), // garis outline
                      minimumSize: const Size(double.infinity, 48),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // tanpa rounded
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
            onPressed: showFilterDialog,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : filteredData.isEmpty
          ? Center(child: Text("Tidak ada data"))
          : ListView(
              padding: const EdgeInsets.only(top: 16),
              children: filteredData.map(buildLendingCard).toList(),
            ),
    );
  }
}
