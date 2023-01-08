import 'dart:math';

import 'package:intl/intl.dart';

int random6digit() {
  var rnd = Random();
  var next = rnd.nextDouble() * 1000000;
  while (next < 100000) {
    next *= 10;
  }
  return next.toInt();
}

String removeBracket(String num) {
  return num.replaceAll(RegExp(r"\p{P}", unicode: true), "");
}

String convertToCurrencyFormat(
  num? number, {
  bool toInt = false,
  String symbol = "₮",
  bool isBalanceHide = false,
  bool locatedAtTheEnd = false,
}) {
  String mSymbol = symbol;

  if (isBalanceHide) {
    return locatedAtTheEnd ? '***.** $mSymbol' : '$mSymbol ***.**';
  }

  if (number != null) {
    try {
      var format = toInt ? NumberFormat("#,###") : NumberFormat("#,##0.00");

      return locatedAtTheEnd
          ? format.format(number) + ' $mSymbol'
          : '$mSymbol ' + format.format(number);
    } catch (e) {
      return '$mSymbol 0';
    }
  }
  return '$mSymbol 0';
}
