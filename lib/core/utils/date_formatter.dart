import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String dayName(DateTime date) {
    return DateFormat('EEE').format(date);
  }

  static String fullDate(DateTime date) {
    return DateFormat('EEE, MMM d').format(date);
  }

  static String hour(DateTime date) {
    return DateFormat('ha').format(date);
  }

  static String lastUpdated(DateTime date) {
    return DateFormat('MMM d, h:mm a').format(date);
  }
}