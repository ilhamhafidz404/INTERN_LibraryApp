import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intern_libraryapp/models/book_response.dart';
import 'package:intern_libraryapp/pages/book/book_detail_page.dart';
import 'package:intern_libraryapp/services/book_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Book> books = [];
  List<Book> filteredBooks = [];
  bool isLoading = true;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchBooks();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredBooks = books.where((book) {
        return book.title.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cari Buku')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search by title...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38, width: 1),
                ),
                floatingLabelStyle: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (filteredBooks.isEmpty)
              const Center(child: Text("Buku tidak ditemukan"))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: filteredBooks.length,
                  itemBuilder: (context, index) =>
                      buildVerticalBookCard(filteredBooks[index]),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildVerticalBookCard(Book book) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BookDetailPage(book: book)),
          );
        },
        child: Card(
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    '${dotenv.env['BASE_URL']}/uploads/${book.cover}',
                    width: 80,
                    height: 110,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        book.author,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
