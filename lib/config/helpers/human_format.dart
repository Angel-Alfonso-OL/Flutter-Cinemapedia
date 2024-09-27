import 'package:intl/intl.dart';


class HumansFormat {
  static String number(double number, [int decimals = 0]){
    return NumberFormat.compactCurrency(
      decimalDigits: decimals,
      symbol: "",
      locale: "en"
    ).format(number);
    
  }
}