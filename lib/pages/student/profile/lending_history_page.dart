import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intern_libraryapp/models/lending_history_response.dart';
import 'package:intern_libraryapp/services/lending_history_service.dart';

class LendingHistoryPage extends StatefulWidget {
  @override
  _LendingHistoryPageState createState() => _LendingHistoryPageState();
}

class _LendingHistoryPageState extends State<LendingHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<LendingHistory> allData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // hanya 2 tab
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await LendingHistoryService().getHistories();
      setState(() {
        allData = response.data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      // print('Gagal mengambil data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data peminjaman')),
      );
    }
  }

  List<LendingHistory> filterByStatus(String status) {
    if (status == 'history') {
      return allData
          .where(
            (item) =>
                item.status == 'returned' || item.status == 'late returned',
          )
          .toList();
    }
    return allData.where((item) => item.status == status).toList();
  }

  Widget buildLendingCard(LendingHistory item) {
    final formatter = DateFormat('dd MMM yyyy');

    // Ganti status menjadi teks yang lebih ramah
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
      // color: Colors.white,
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

  Widget buildTabContent(String status) {
    final filtered = filterByStatus(status);
    if (filtered.isEmpty) return Center(child: Text('Tidak ada data'));
    return ListView(
      padding: const EdgeInsets.only(top: 16),
      children: filtered.map(buildLendingCard).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Peminjaman'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Color(0xFFed5d5e),
          indicatorColor: Color(0xFFed5d5e),
          tabs: [
            Tab(text: 'Dipinjam'),
            Tab(text: 'Riwayat'),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [buildTabContent('loaned'), buildTabContent('history')],
            ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
