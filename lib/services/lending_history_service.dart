import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intern_libraryapp/models/lending_history_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LendingHistoryService {
  Future<LendingHistoryResponse> getHistories() async {
    final url = Uri.parse('http://192.168.49.246:3000/api/lending-history');

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
        return LendingHistoryResponse.fromJson(json);
      } catch (e) {
        throw Exception('Gagal parsing response: $e');
      }
    } else {
      throw Exception('Gagal mengambil data buku: ${response.body}');
    }
  }

  Future<PostLendingHistoryResponse> postHistory({
    required int studentId,
    required int bookId,
    required String startDate,
    required String endDate,
  }) async {
    final url = Uri.parse('http://192.168.49.246:3000/api/lending-history');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('Token tidak tersedia. Silakan login kembali.');
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'student_id': studentId,
        'book_id': bookId,
        'start_date': startDate,
        'end_date': endDate,
        'status': 'loaned',
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return PostLendingHistoryResponse.fromJson(json);
      } catch (e) {
        throw Exception('Gagal parsing response: $e');
      }
    } else {
      throw Exception('Gagal menambahkan data peminjaman: ${response.body}');
    }
  }

  Future<PostLendingHistoryResponse> deleteHistory(int id) async {
    final url = Uri.parse('http://192.168.49.246:3000/api/lending-history/$id');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('Token tidak tersedia. Silakan login kembali.');
    }

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return PostLendingHistoryResponse.fromJson(json);
      } catch (e) {
        throw Exception('Gagal parsing response delete: $e');
      }
    } else {
      throw Exception('Gagal menghapus data peminjaman: ${response.body}');
    }
  }
}
