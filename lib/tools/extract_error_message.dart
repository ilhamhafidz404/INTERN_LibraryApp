import 'dart:convert';

String extractErrorMessage(String exceptionString) {
  try {
    final startIndex = exceptionString.indexOf('{');
    if (startIndex == -1) return "Terjadi kesalahan tidak diketahui";

    final jsonString = exceptionString.substring(startIndex);
    final Map<String, dynamic> json = jsonDecode(jsonString);

    return json['message'] ?? "Terjadi kesalahan saat login";
  } catch (e) {
    return "Terjadi kesalahan saat memproses error";
  }
}
