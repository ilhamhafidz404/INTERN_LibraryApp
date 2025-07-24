// pages/book_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intern_libraryapp/models/book_response.dart';

class BookDetailPage extends StatelessWidget {
  final Book book;

  const BookDetailPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  '${dotenv.env['BASE_URL']}/uploads/${book.cover}',
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              book.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(book.author, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text(
              "Penerbit : ${book.publisher}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text("ISBN : ${book.isbn}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 5),
            Text(
              "Tahun Terbit : ${book.year}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              "Jumlah : ${book.total}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            // Text(
            //   book.description ?? 'No description available.',
            //   style: const TextStyle(fontSize: 15),
            // ),
          ],
        ),
      ),
    );
  }
}
