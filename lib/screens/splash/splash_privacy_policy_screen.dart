import 'package:Erdenet24/widgets/header.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SplashPrivacyPolicyScreen extends StatefulWidget {
  const SplashPrivacyPolicyScreen({super.key});

  @override
  State<SplashPrivacyPolicyScreen> createState() =>
      _SplashPrivacyPolicyScreenState();
}

class _SplashPrivacyPolicyScreenState extends State<SplashPrivacyPolicyScreen> {
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory(() => EagerGestureRecognizer())
  };

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      title: "Үйлчилгээний нөхцөл",
      customActions: Container(),
      body: SizedBox(
        height: Get.height,
        child: WebViewWidget(
          gestureRecognizers: gestureRecognizers,
          controller: WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setNavigationDelegate(
              NavigationDelegate(
                onProgress: (int progress) {},
                onPageStarted: (String url) {},
                onPageFinished: (String url) {},
                onWebResourceError: (WebResourceError error) {},
              ),
            )
            ..loadRequest(
              Uri.parse('https://sites.google.com/view/erdenet24/home'),
            ),
        ),
      ),
    );
  }
}
