import 'package:Erdenet24/widgets/header.dart';
import "package:flutter/material.dart";

class StorePayment extends StatefulWidget {
  const StorePayment({super.key});

  @override
  State<StorePayment> createState() => _StorePaymentState();
}

class _StorePaymentState extends State<StorePayment> {
  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      title: "Төлбөрийн мэдээл",
    );
  }
}
