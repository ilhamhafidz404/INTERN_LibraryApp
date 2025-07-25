import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intern_libraryapp/models/book_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookService {
  Future<BookResponse> getBooks() async {
    // final url = Uri.parse('http://localhost:3000/api/books');
    final url = Uri.parse('http://192.168.49.246:3000/api/books');
    // final url = Uri.parse('http://10.1.19.2:3000/api/books');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('Token tidak tersedia. Silakan login kembali.');
    }

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      try {
        final json = jsonDecode(response.body);
        print(json);
        return BookResponse.fromJson(json);
      } catch (e) {
        throw Exception('Gagal parsing response: $e');
      }
    } else {
      throw Exception('Gagal mengambil data buku: ${response.body}');
    }
  }

  Future<void> storeBook({
    required String title,
    required String publisher,
    required String author,
    required String isbn,
    required String year,
    required String total,
    required File coverFile,
  }) async {
    final url = Uri.parse('http://192.168.49.246:3000/api/books');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('Token tidak tersedia. Silakan login kembali.');
    }

    var request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['title'] = title
      ..fields['publisher'] = publisher
      ..fields['author'] = author
      ..fields['isbn'] = isbn
      ..fields['year'] = year
      ..fields['total'] = total
      ..files.add(
        await http.MultipartFile.fromPath(
          'cover',
          coverFile.path,
          contentType: MediaType('image', 'avif'),
        ),
      );

    final response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final json = jsonDecode(respStr);
      print('Success: $json');
    } else {
      final error = await response.stream.bytesToString();
      throw Exception('Gagal menyimpan buku: $error');
    }
  }
}
