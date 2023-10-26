import 'package:intl/intl.dart';

extension DateTimeEx on DateTime {
  String get mDY {
    return DateFormat('MMMM d, yyyy').format(this);
  }
}
