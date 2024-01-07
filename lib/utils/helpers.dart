import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

final player = AudioPlayer();
void playSound(type, {bool loop = false}) async {
  player.play(AssetSource("sounds/$type.wav"), volume: 100);
  if (loop) {
    player.onPlayerComplete.listen((event) {
      player.play(
        AssetSource("sounds/$type.wav"),
      );
    });
  }
}

void stopSound() async {
  player.stop();
}

int random4digit() {
  var rnd = Random();
  var next = rnd.nextDouble() * 10000;
  while (next < 1000) {
    next *= 10;
  }
  return next.toInt();
}

int random3digit() {
  var rnd = Random();
  var next = rnd.nextDouble() * 1000;
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
  String symbol = "₮",
  bool isBalanceHide = false,
}) {
  String mSymbol = symbol;

  if (isBalanceHide) {
    return '***.** $mSymbol';
  }

  if (number != null) {
    try {
      var format = NumberFormat("#,###");
      return '${format.format(number)} $mSymbol';
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

List statusList = [
  {"status": "notPaid", "text": "Төлбөр төлөөгүй", "color": Colors.blue},
  {"status": "sent", "text": "Төлбөр төлсөн", "color": Colors.orange},
  {
    "status": "received",
    "text": "Захиалгыг хүлээн авсан",
    "color": Colors.cyanAccent
  },
  {
    "status": "driverAccepted",
    "text": "Жолооч хүлээн авсан",
    "color": Colors.blueAccent
  },
  {"status": "preparing", "text": "Бэлдэж байна", "color": Colors.amber},
  {"status": "delivering", "text": "Хүргэж байгаа", "color": Colors.brown},
  {"status": "delivered", "text": "Хүргэсэн", "color": Colors.green},
  {"status": "canceled", "text": "Цуцалсан", "color": Colors.red},
];

Map status(String text) {
  Map obj = statusList.firstWhere((element) => element["status"] == text);
  return obj;
}
