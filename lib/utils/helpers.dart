import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

int random4digit() {
  var rnd = Random();
  var next = rnd.nextDouble() * 10000;
  while (next < 1000) {
    next *= 10;
  }
  return next.toInt();
}

int random6digit() {
  var rnd = Random();
  var next = rnd.nextDouble() * 1000000;
  while (next < 100000) {
    next *= 10;
  }
  return next.toInt();
}

String removeBracket(String num) {
  return num.replaceAll("(", "").replaceAll(")", " ");
}

String formattedTime(DateTime time) {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String formatted = formatter.format(time);
  return formatted;
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

Future<void> makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}

List notificationData = [
  {
    "role": "user",
    "action": "payment_success",
    "description": "Захиалгын төлбөр амжилттай төлөгдлөө",
    "showNotification": true
  },
  {
    "role": "user",
    "action": "sent",
    "description": "Захиалгыг хүлээн авлаа",
    "showNotification": true
  },
  {
    "role": "user",
    "action": "sent",
    "description": "Захиалгыг хүлээн авлаа",
    "showNotification": true
  },
  {
    "role": "user",
    "action": "received",
    "description": "Таны захиалгыг хүлээн авлаа",
    "showNotification": true
  },
  {
    "role": "user",
    "action": "preparing",
    "description": "Таны захиалгыг бэлтгэж эхэллээ",
    "showNotification": true
  },
  {
    "role": "user",
    "action": "delivering",
    "description": "Таны захиалга хүргэлтэнд гарлаа",
    "showNotification": true
  },
  {
    "role": "user",
    "action": "delivered",
    "description": "Таны захиалга амжилттай хүргэгдлээ",
    "showNotification": true
  },
  {
    "role": "store",
    "action": "sent",
    "description": "Шинэ захиалга ирлээ",
    "showNotification": true
  },
  {
    "role": "store",
    "action": "received",
    "description": "Захиалгыг хүлээн авлаа",
    "showNotification": true
  },
  {
    "role": "store",
    "action": "driverAccepted",
    "description": "Жолооч дуудлага хүлээн авлаа",
    "showNotification": true
  },
  {
    "role": "store",
    "action": "delivering",
    "description": "Хүргэлтэнд гарлаа",
    "showNotification": true
  },
  {
    "role": "store",
    "action": "delivered",
    "description": "Хүргэлт амжилттай",
    "showNotification": true
  },
  {
    "role": "driver",
    "action": "new_order",
    "description": "Шинэ захиалга ирлээ",
    "showNotification": true
  },
];
String notificationDescription(role, action) {
  Map result = notificationData
      .firstWhere((e) => e["role"] == role && e["action"] == action);
  return result["description"];
}

bool notificationShow(role, action) {
  Map result = notificationData
      .firstWhere((e) => e["role"] == role && e["action"] == action);
  return result["showNotification"];
}
