import 'dart:async';
import 'package:Erdenet24/screens/splash/phone_register.dart';
import "package:flutter/material.dart";
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Timer(
    //   const Duration(seconds: 5000),
    //   () => Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => const PhoneRegister()),
    //   ),
    // );
  }

  @override
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            Column(
              children: [
                Image(
                  image: const AssetImage("assets/images/png/splash1.png"),
                  width: _width * .22,
                ),
                const SizedBox(height: 24),
                const Text(
                  "ERDENET24",
                  softWrap: true,
                  style: TextStyle(
                    fontFamily: "Exo",
                    fontSize: 22,
                    color: MyColors.black,
                  ),
                )
              ],
            ),
            Column(
              children: [
                // SizedBox(
                //   width: 20,
                //   height: 20,
                //   child: CircularProgressIndicator(
                //     color: MyColors.primary,
                //     strokeWidth: 2,
                //   ),
                // ),
                // SizedBox(height: 24),
                CustomText(
                  text: "Тун удахгүй",
                  fontSize: 12,
                ),
                SizedBox(height: _height * .05)
              ],
            )
          ],
        ),
      ),
    );
  }
}
