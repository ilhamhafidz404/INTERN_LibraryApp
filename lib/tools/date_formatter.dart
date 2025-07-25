import 'package:intl/intl.dart';

String dateFormatter(String input) {
  try {
    final parsed = DateFormat('dd-MM-yyyy').parseStrict(input);
    return parsed.toIso8601String();
  } catch (e) {
    return input;
  }
}
