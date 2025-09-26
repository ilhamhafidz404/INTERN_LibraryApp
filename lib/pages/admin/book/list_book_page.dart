import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intern_libraryapp/models/book_response.dart';
import 'package:intern_libraryapp/services/book_service.dart';
import 'package:intern_libraryapp/pages/admin/book/create_book_page.dart';
import 'package:intern_libraryapp/pages/admin/book/update_book_page.dart';

class AdminBookListPage extends StatefulWidget {
  @override
  _AdminBookListPageState createState() => _AdminBookListPageState();
}

class _AdminBookListPageState extends State<AdminBookListPage> {
  List<Book> books = [];
  List<Book> filteredBooks = [];
  bool isLoading = true;

  // Filter state
  String? filterBook;

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    try {
      final response = await BookService().getBooks();
      setState(() {
        books = response.data;
        filteredBooks = books;
        isLoading = false;
      });
    } catch (e) {
      print('Gagal mengambil buku: $e');
      setState(() => isLoading = false);
    }
  }

  void applyFilter() {
    setState(() {
      filteredBooks = books.where((book) {
        final matchesBook = filterBook == null || filterBook!.isEmpty
            ? true
            : book.title.toLowerCase().contains(filterBook!.toLowerCase());
        return matchesBook;
      }).toList();
    });
  }

  void resetFilter() {
    setState(() {
      filterBook = null;
      filteredBooks = books;
    });
  }

  Future<void> showFilterDialog() async {
    final bookController = TextEditingController(text: filterBook);

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
                    "Filter Buku",
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

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      // Tombol Reset (3/12)
                      Expanded(
                        flex: 3,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFFed5d5e),
                              width: 1.5,
                            ),
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

                      // Tombol Terapkan Filter (9/12)
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
                            filterBook = bookController.text;
                            applyFilter();
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Terapkan Filter",
                            style: TextStyle(color: Colors.white, fontSize: 14),
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

  void _createBook() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AdminCreateBookPage()),
    );
  }

  void _updateBook(Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AdminEditBookPage(book: book)),
    );
  }

  void _deleteBook(Book book) async {
    try {
      await BookService().deleteBook(book.id);
      setState(() {
        books.remove(book);
        filteredBooks = books;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Buku berhasil dihapus')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menghapus buku: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Buku'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: showFilterDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFFed5d5e)),
              )
            : filteredBooks.isEmpty
            ? const Center(child: Text('Tidak ada buku ditemukan'))
            : RefreshIndicator(
                color: Color(0xFFed5d5e),
                onRefresh: fetchBooks,
                child: ListView.builder(
                  itemCount: filteredBooks.length,
                  itemBuilder: (context, index) {
                    final book = filteredBooks[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            '${dotenv.env['BASE_URL']}/uploads/${book.cover}',
                            width: 70,
                            height: 150,
                            errorBuilder: (_, __, ___) => Container(
                              width: 70,
                              height: 150,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image),
                            ),
                          ),
                        ),
                        title: Text(book.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Text('Penulis: ${book.author}'),
                            Text('ISBN: ${book.isbn}'),
                            const SizedBox(height: 20),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              _updateBook(book);
                            } else if (value == 'delete') {
                              _deleteBook(book);
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(value: 'edit', child: Text('Edit')),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createBook, // fungsi menuju halaman tambah
        backgroundColor: const Color(0xFFed5d5e),
        tooltip: 'Tambah Buku',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
