import 'dart:math';
import 'package:Erdenet24/utils/styles.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
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

Color handleOrderStatusColor(String status) {
  if (status == "preparing") {
    return Colors.amber;
  } else if (status == "waitingForDriver") {
    return Colors.blue;
  } else if (status == "delivering") {
    return Colors.brown;
  } else if (status == "delivered") {
    return Colors.green;
  } else if (status == "canceled") {
    return Colors.red;
  } else {
    return Colors.amber;
  }
}

String handleOrderStatusText(String status) {
  if (status == "sent") {
    return "Баталгаажсан";
  } else if (status == "preparing") {
    return "Бэлдэж байна";
  } else if (status == "waitingForDriver") {
    return "Жолооч хүлээж байна";
  } else if (status == "driverAccepted") {
    return "Бэлдэж байна";
  } else if (status == "delivering") {
    return "Хүргэж байна";
  } else if (status == "delivered") {
    return "Хүргэсэн";
  } else if (status == "canceled") {
    return "Цуцалсан";
  } else {
    return "";
  }
}

IconData handleOrderStatusIcon(String orderStatus) {
  if (orderStatus == "sent") {
    return IconlyLight.document;
  } else if (orderStatus == "preparing") {
    return IconlyLight.time_circle;
  } else if (orderStatus == "delivering") {
    return IconlyLight.location;
  } else if (orderStatus == "delivered") {
    return IconlyLight.tick_square;
  } else {
    return IconlyLight.paper_fail;
  }
}

Widget status(String status) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        Icons.circle_rounded,
        size: 8,
        color: handleOrderStatusColor(status),
      ),
      SizedBox(width: Get.width * .02),
      Text(
        handleOrderStatusText(status),
        style: const TextStyle(fontSize: 8),
      )
    ],
  );
}

Widget orderStatusLine(String orderStatus) {
  if (orderStatus == "sent") {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _d(true),
        _l(false),
        _d(false),
        _l(false),
        _d(false),
        _l(false),
        _d(false),
      ],
    );
  } else if (orderStatus == "preparing") {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _d(true),
        _l(true),
        _d(true),
        _l(false),
        _d(false),
        _l(false),
        _d(false),
      ],
    );
  } else if (orderStatus == "delivering") {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _d(true),
        _l(true),
        _d(true),
        _l(true),
        _d(true),
        _l(false),
        _d(false),
      ],
    );
  } else if (orderStatus == "delivered") {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _d(true),
        _l(true),
        _d(true),
        _l(true),
        _d(true),
        _l(true),
        _d(true),
      ],
    );
  } else {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _d(true),
        _l(false),
        _d(false),
        _l(false),
        _d(false),
        _l(false),
        _d(false),
      ],
    );
  }
}

Widget _d(bool isActive) {
  return Container(
    width: 12,
    height: 12,
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: isActive ? MyColors.primary : Colors.black,
      shape: BoxShape.circle,
    ),
  );
}

Widget _l(bool isActive) {
  return Expanded(
    child: Container(
      height: 3,
      decoration: BoxDecoration(
        color: isActive ? MyColors.primary : Colors.black,
      ),
    ),
  );
}
