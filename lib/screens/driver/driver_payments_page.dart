import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';

class DriverPaymentsPage extends StatefulWidget {
  const DriverPaymentsPage({super.key});

  @override
  State<DriverPaymentsPage> createState() => _DriverPaymentsPageState();
}

class _DriverPaymentsPageState extends State<DriverPaymentsPage> {
  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      title: "Төлбөр тооцоо",
      customActions: Container(),
    );
  }
}
