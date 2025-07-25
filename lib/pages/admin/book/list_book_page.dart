import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intern_libraryapp/pages/admin/book/create_book_page.dart';
import 'package:intern_libraryapp/services/book_service.dart';
import 'package:intern_libraryapp/models/book_response.dart'; // sesuaikan path model Book kamu

class AdminBookListPage extends StatefulWidget {
  @override
  _AdminBookListPageState createState() => _AdminBookListPageState();
}

class _AdminBookListPageState extends State<AdminBookListPage> {
  final TextEditingController _searchController = TextEditingController();

  List<Book> books = [];
  List<Book> filteredBooks = [];
  bool isLoading = true;

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

  void _filterBooks(String query) {
    setState(() {
      filteredBooks = books
          .where(
            (book) =>
                book.title.toLowerCase().contains(query.toLowerCase()) ||
                book.author.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  void _createBook() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AdminCreateBookPage()),
    );
  }

  void _updateBook(Book book) {
    // Navigasi ke halaman update book
  }

  void _deleteBook(Book book) async {
    print(book.id);
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
        title: const Text('Daftar Buku (Admin)'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _searchController,
                    onChanged: _filterBooks,
                    decoration: const InputDecoration(
                      labelText: 'Cari Judul Buku',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: _createBook,
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'Tambah',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFed5d5e),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredBooks.isEmpty
                  ? const Center(child: Text('Tidak ada buku ditemukan'))
                  : ListView.builder(
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
                                SizedBox(height: 10),
                                Text('Penulis: ${book.author}'),
                                Text('ISBN: ${book.isbn}'),
                                SizedBox(height: 20),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'update') {
                                  _updateBook(book);
                                } else if (value == 'delete') {
                                  _deleteBook(book);
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'update',
                                  child: Text('Update'),
                                ),
                                const PopupMenuItem(
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
          ],
        ),
      ),
    );
  }
}
