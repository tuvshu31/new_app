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

List<Map<String, dynamic>> notificationData = [
  {
    "role": "user",
    "action": "payment_success",
    "body": "Захиалгын төлбөр амжилттай төлөгдлөө",
    "visible": true,
    "type": "message",
  },
  {
    "role": "user",
    "action": "sent",
    "body": "Захиалгыг хүлээн авлаа",
    "visible": true,
    "type": "message",
  },
  {
    "role": "user",
    "action": "sent",
    "body": "Захиалгыг хүлээн авлаа",
    "visible": true,
    "type": "message",
  },
  {
    "role": "user",
    "action": "received",
    "body": "Таны захиалгыг хүлээн авлаа",
    "visible": true,
    "type": "message",
  },
  {
    "role": "user",
    "action": "preparing",
    "body": "Таны захиалгыг бэлтгэж эхэллээ",
    "visible": true,
    "type": "message",
  },
  {
    "role": "user",
    "action": "delivering",
    "body": "Таны захиалга хүргэлтэнд гарлаа",
    "visible": true,
    "type": "message",
  },
  {
    "role": "user",
    "action": "delivered",
    "body": "Таны захиалга амжилттай хүргэгдлээ",
    "visible": true,
    "type": "message",
  },
  {
    "role": "store",
    "action": "sent",
    "body": "Шинэ захиалга ирлээ",
    "visible": true,
    "type": "message",
  },
  {
    "role": "store",
    "action": "received",
    "body": "Захиалгыг хүлээн авлаа",
    "visible": true,
    "type": "message",
  },
  {
    "role": "store",
    "action": "driverAccepted",
    "body": "Жолооч дуудлага хүлээн авлаа",
    "visible": true,
    "type": "message",
  },
  {
    "role": "store",
    "action": "delivering",
    "body": "Хүргэлтэнд гарлаа",
    "visible": true,
    "type": "message",
  },
  {
    "role": "store",
    "action": "canceled",
    "body": "Жолооч дуудлагаа цуцаллаа",
    "visible": true,
    "type": "message",
  },
  {
    "role": "store",
    "action": "delivered",
    "body": "Хүргэлт амжилттай",
    "visible": true,
    "type": "message",
  },
  {
    "role": "driver",
    "action": "new_order",
    "body": "Шинэ захиалга ирлээ",
    "visible": true,
    "type": "message",
  },
];
List testNumbersToGetOrderNotifications = ["98080064, 99921312,"];
String notifRole(payload) {
  var role = notificationData.firstWhere((element) =>
      element["role"] == payload["role"] &&
      element["action"] == payload["action"])["role"];
  return role;
}

String notifType(payload) {
  var role = notificationData.firstWhere((element) =>
      element["role"] == payload["role"] &&
      element["action"] == payload["action"])["type"];
  return role;
}

String notifBody(payload) {
  var role = notificationData.firstWhere((element) =>
      element["role"] == payload["role"] &&
      element["action"] == payload["action"])["body"];
  return role;
}

String formatedTime({required int timeInSecond}) {
  int sec = timeInSecond % 60;
  int min = (timeInSecond / 60).floor();
  String minute = min.toString().length <= 1 ? "0$min" : "$min";
  String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
  return "$minute мин $second сек";
}

List reversedArray(List myList) {
  for (var i = 0; i < myList.length / 2; i++) {
    var temp = myList[i];
    myList[i] = myList[myList.length - 1 - i];
    myList[myList.length - 1 - i] = temp;
  }
  return myList;
}

Map statusInfo(String status) {
  var obj = {};
  if (status == "notPaid") {
    obj = {
      "text": 'Төлбөр төлөөгүй',
      "step": 1,
      "icon": Icons.money_off_rounded
    };
  } else if (status == "sent") {
    obj = {
      "text": 'Төлбөр төлсөн',
      "step": 1,
      "icon": Icons.attach_money_rounded,
    };
  } else if (status == "received") {
    obj = {
      "text": 'Баталгаажсан',
      "step": 1,
      "icon": Icons.approval,
    };
  } else if (status == "driverAccepted") {
    obj = {
      "text": 'Жолооч хүлээн авсан',
      "step": 1,
      "icon": Icons.drive_eta_rounded
    };
  } else if (status == "preparing") {
    obj = {
      "text": 'Бэлдэж байна',
      "step": 2,
      "icon": Icons.timelapse,
    };
  } else if (status == "delivering") {
    obj = {
      "text": 'Хүргэж байна',
      "step": 3,
      "icon": Icons.local_taxi,
    };
  } else if (status == "delivered") {
    obj = {
      "text": 'Хүргэсэн',
      "step": 4,
      "icon": Icons.done_all_rounded,
    };
  } else if (status == "canceled") {
    obj = {
      "text": 'Цуцалсан',
      "step": 4,
      "icon": Icons.cancel_outlined,
    };
  } else {
    obj = {
      "text": 'Error',
      "step": 4,
      "icon": Icons.error,
    };
  }
  return obj;
}
