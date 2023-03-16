import 'dart:io';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/notifications.dart';
import 'package:Erdenet24/screens/splash/splash_main_screen.dart';
import 'package:Erdenet24/screens/store/store_main_screen.dart';
import 'package:Erdenet24/screens/user/user_category_products_screen.dart';
import 'package:Erdenet24/screens/user/user_orders_active_screen.dart';
import 'package:Erdenet24/screens/user/user_profile_help_screen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/cart_controller.dart';
import 'package:Erdenet24/controller/login_controller.dart';
import 'package:Erdenet24/controller/product_controller.dart';
import 'package:Erdenet24/screens/driver/driver_main_screen.dart';
import 'package:Erdenet24/screens/user/user_cart_screen.dart';
import 'package:Erdenet24/screens/user/user_home_screen.dart';
import 'package:Erdenet24/screens/user/user_subcategory_products_screen.dart';
import 'package:Erdenet24/screens/user/user_products_screen_new.dart';
import 'package:Erdenet24/screens/user/user_search_main_screen.dart';
import 'package:Erdenet24/screens/user/user_cart_address_info_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  switchNotifications(message.data, true);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: "basic_channel",
        channelName: "Basic Notification",
        channelDescription: "Notification channel for basic test",
        playSound: false,
        importance: NotificationImportance.High,
        soundSource: 'resource://raw/incoming',
      ),
    ],
    debug: true,
  );
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    switchNotifications(message.data, false);
  });

  await Hive.initFlutter();
  RestApiHelper.authBox = await Hive.openBox('myBox');
  if (Platform.isAndroid) {
    GeolocatorAndroid.registerWith();
  } else if (Platform.isIOS) {
    // GeolocatorApple.registerWith();
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) {
    if (RestApiHelper.getUserId() == 0) {
      runApp(const MyApp(
        initialRoute: '/SplashScreenRoute',
      ));
    } else if (RestApiHelper.getUserRole() == "store") {
      runApp(const MyApp(
        initialRoute: "/StoreScreenRoute",
      ));
    } else if (RestApiHelper.getUserRole() == "user") {
      if (RestApiHelper.getOrderId() != 0) {
        runApp(const MyApp(
          initialRoute: "/UserOrderActiveRoute",
        ));
      } else {
        runApp(const MyApp(
          initialRoute: "/MainScreenRoute",
        ));
      }
    } else if (RestApiHelper.getUserRole() == "driver") {
      runApp(const MyApp(
        initialRoute: "/DriverScreenRoute",
      ));
    } else {
      runApp(const MyApp(
        initialRoute: "/SplashScreenRoute",
      ));
    }
  });
}

class MyApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  final String initialRoute;
  const MyApp({
    Key? key,
    this.initialRoute = "/",
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //Huudas shiljiheer ondelete hiigdeed bga blhoor eniig duudaj bga. Ustgaj bolohgui
  final cartCtrl = Get.put(CartController(), permanent: true);
  final loginCtrl = Get.put(LoginController(), permanent: true);
  final productCtrl = Get.put(ProductController(), permanent: true);
  //Login hiisen hereglegchiin token.g database deer hadgalj avah

  @override
  void initState() {
    super.initState();

    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: MyApp.navigatorKey,
      title: "Erdenet24",
      initialRoute: widget.initialRoute,
      // defaultTransition: Transition.,
      theme: ThemeData(fontFamily: 'Nunito'),
      getPages: [
        GetPage(name: "/", page: () => const UserHomeScreen()),
        GetPage(
            name: "/SplashScreenRoute", page: () => const SplashMainScreen()),
        GetPage(name: "/StoreScreenRoute", page: () => const StoreMainScreen()),
        // GetPage(name: "/MainScreenRoute", page: () => const ),
        GetPage(
            name: "/DriverScreenRoute", page: () => const DriverMainScreen()),
        GetPage(
            name: "/UserSettingsRoute",
            page: () => const UserProfileHelpScreen()),
        GetPage(name: "/CartRoute", page: () => const UserCartScreen()),
        GetPage(
            name: "/CategoryRoute",
            page: () => const UserCategoryProductScreen()),
        GetPage(name: "/MainScreen", page: () => const UserHomeScreen()),
        GetPage(
            name: "/CategoryNoTabbar",
            page: () => const UserSubCategoryProductsScreen()),
        GetPage(
            name: "/ProductsRoute", page: () => const UserProductScreenNew()),
        GetPage(name: "/SearchRoute", page: () => const UserSearchMainScreen()),
        GetPage(
            name: "/OrdersRoute",
            page: () => const UserCartAddressInfoScreen()),
        GetPage(
            name: "/UserOrderActiveRoute",
            page: () => const UserOrderActiveScreen()),
      ],
    );
  }
}
