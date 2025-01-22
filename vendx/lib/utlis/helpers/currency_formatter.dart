import 'package:intl/intl.dart';

String formatCurrency(double amount) {
  final NumberFormat currencyFormat = NumberFormat.currency(
    locale: 'en_DE',
    symbol: '€',
    decimalDigits: 2,
  );

  return currencyFormat.format(amount);
}
