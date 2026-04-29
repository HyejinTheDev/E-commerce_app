import 'package:intl/intl.dart';

/// Format số tiền sang VND
/// Ví dụ: 89.00 → "2.225.000₫"
class CurrencyFormatter {
  CurrencyFormatter._();

  static final _formatter = NumberFormat('#,###', 'vi_VN');

  /// Tỷ giá quy đổi USD → VND
  static const double exchangeRate = 25000;

  /// Format giá VND từ giá USD gốc
  static String formatVnd(double usdPrice) {
    final vnd = (usdPrice * exchangeRate).round();
    return '${_formatter.format(vnd)}₫';
  }

  /// Format giá VND (đã là VND, không cần quy đổi)
  static String formatRawVnd(double vndPrice) {
    return '${_formatter.format(vndPrice.round())}₫';
  }
}
