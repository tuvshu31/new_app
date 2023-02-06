import 'package:Erdenet24/widgets/header.dart';
import 'package:flutter/material.dart';

class DriverDeliverListPage extends StatefulWidget {
  const DriverDeliverListPage({super.key});

  @override
  State<DriverDeliverListPage> createState() => _DriverDeliverListPageState();
}

class _DriverDeliverListPageState extends State<DriverDeliverListPage> {
  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      title: "Хүргэлтүүд",
      customActions: Container(),
    );
  }
}
