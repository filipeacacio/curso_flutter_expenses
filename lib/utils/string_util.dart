
import 'package:intl/intl.dart';

class StringUtil {
  static String NumberFormatBR(num value) {
    final formatter = NumberFormat('#,##0.00', 'pt_BR');
    return formatter.format(value);
  }

  static String DateTimeFormatBR(DateTime date, {String pattern = 'dd/MM/y'}) {
    return DateFormat(pattern).format(date);
  }
}
