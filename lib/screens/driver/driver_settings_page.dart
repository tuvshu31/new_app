import 'package:Erdenet24/widgets/header.dart';
import 'package:flutter/material.dart';

class DriverSettingsPage extends StatefulWidget {
  const DriverSettingsPage({super.key});

  @override
  State<DriverSettingsPage> createState() => _DriverSettingsPageState();
}

class _DriverSettingsPageState extends State<DriverSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      title: "Тохиргоо",
      customActions: Container(),
    );
  }
}
