// I love you my super dad heart (Ruby)
import 'dart:async';
import 'dart:io';
import 'package:Erdenet24/api/local_notification.dart';
import 'package:Erdenet24/api/socket_instance.dart';
import 'package:Erdenet24/controller/data_controller.dart';
import 'package:Erdenet24/screens/driver/driver_deliver_list_screen.dart';
import 'package:Erdenet24/screens/driver/driver_main_screen.dart';
import 'package:Erdenet24/screens/driver/driver_payments_screen.dart';
import 'package:Erdenet24/screens/driver/driver_settings_screen.dart';
import 'package:Erdenet24/screens/splash/splash_main_screen.dart';
import 'package:Erdenet24/screens/splash/splash_otp_screen.dart';
import 'package:Erdenet24/screens/splash/splash_phone_register_screen.dart';
import 'package:Erdenet24/screens/splash/splash_privacy_policy_screen.dart';
import 'package:Erdenet24/screens/splash/splash_prominent_disclosure_screen.dart';
import 'package:Erdenet24/screens/store/store_edit_product_screen.dart';
import 'package:Erdenet24/screens/store/store_main_screen.dart';
import 'package:Erdenet24/screens/store/store_orders_detail_screen.dart';
import 'package:Erdenet24/screens/store/store_orders_screen.dart';
import 'package:Erdenet24/screens/store/store_products_add_screen.dart';
import 'package:Erdenet24/screens/store/store_products_edit_screen.dart';
import 'package:Erdenet24/screens/store/store_settings_screen.dart';
import 'package:Erdenet24/screens/user/user_home_screen.dart';
import 'package:Erdenet24/screens/user/user_navigation_drawer_screen.dart';
import 'package:Erdenet24/screens/user/user_payment_screen.dart';
import 'package:Erdenet24/screens/user/user_orders_screen.dart';
import 'package:Erdenet24/screens/user/user_product_detail_screen.dart';
import 'package:Erdenet24/screens/user/user_products_screen.dart';
import 'package:Erdenet24/screens/user/user_products_search_screen.dart';
import 'package:Erdenet24/screens/user/user_profile_address_edit_screen.dart';
import 'package:Erdenet24/screens/user/user_profile_help_screen.dart';
import 'package:Erdenet24/screens/user/user_profile_phone_edit_screen.dart';
import 'package:Erdenet24/screens/user/user_qr_scan_screen.dart';
import 'package:Erdenet24/screens/user/user_saved_screen.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:geolocator_apple/geolocator_apple.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/screens/driver/driver_main_screen_OLD.dart';
import 'package:Erdenet24/screens/user/user_cart_screen.dart';
import 'package:Erdenet24/screens/user/user_search_bar_screen.dart';
import 'package:Erdenet24/screens/user/user_cart_address_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // handleNotifications(message.data);
}

Future<void> _firebaseMessagingForegroundHandler(RemoteMessage message) async {
  // handleNotifications(message.data);
}

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: "Main Navigator");

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotification.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  RestApiHelper.authBox = await Hive.openBox('myBox');
  if (Platform.isIOS) {
    FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  } else if (Platform.isAndroid) {
    FirebaseMessaging.instance.requestPermission();
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(_firebaseMessagingForegroundHandler);

  if (Platform.isAndroid) {
    GeolocatorAndroid.registerWith();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
      ),
    );
  } else if (Platform.isIOS) {
    GeolocatorApple.registerWith();
  }
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then(
    (value) {
      runApp(const MyApp());
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _dataCtx = Get.put(DataController());
  @override
  void initState() {
    super.initState();
    listenToNotification();
    _dataCtx.getMainCategories();
  }

  listenToNotification() {
    print("Listening to notification");
    LocalNotification.onClickNotification.stream.listen((event) {
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => n));
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      title: "Erdenet24",
      initialRoute: splashMainScreenRoute,
      // defaultTransition: Transition.,
      theme: ThemeData(
        fontFamily: 'Rubik',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: <String, WidgetBuilder>{
        splashMainScreenRoute: (context) => const SplashMainScreen(),
        splashOtpScreenRoute: (context) => const SplashOtpScreen(),
        splashPrivacyPolicyRoute: (context) =>
            const SplashPrivacyPolicyScreen(),
        splashProminentDisclosureScreenRoute: (context) =>
            const SplashProminentDisclosure(),
        splashPhoneRegisterScreenRoute: (context) =>
            const SplashPhoneRegisterScreen(),
        userHomeScreenRoute: (context) => const UserHomeScreen(),
        userCartScreenRoute: (context) => const UserCartScreen(),
        userNavigationDrawerScreenRoute: (context) =>
            const UserNavigationDrawerScreen(),
        userCartAddressScreenRoute: (context) => const UserCartAddressScreen(),
        userPaymentScreenRoute: (context) => const UserPaymentScreen(),
        userProductDetailScreenRoute: (context) =>
            const UserProductDetailScreen(),
        userProfileAddressEditScreenRoute: (context) =>
            const UserProfileAddressEditScreen(),
        userProfileHelpScreenRoute: (context) => const UserProfileHelpScreen(),
        userProfileOrdersScreenRoute: (context) => const UserOrdersScreen(),
        userProfilePhoneEditScreenRoute: (context) =>
            const UserProfilePhoneEditScreen(),
        userQrScanScreenRoute: (context) => const UserQRScanScreen(),
        userSavedScreenRoute: (context) => const UserSavedScreen(),
        userSearchBarScreenRoute: (context) => const UserSearchBarScreenRoute(),
        userProductsSearchScreenRoute: (context) =>
            const UserProductsSearchScreen(),
        userProductsScreenRoute: (context) => UserProductsScreen(),
        storeMainScreenRoute: (context) => const StoreMainScreen(),
        storeOrdersScreenRoute: (context) => const StoreOrdersScreen(),
        storeProductsAddScreenRoute: (context) =>
            const StoreProductsAddScreen(),
        storeProductsEditScreenRoute: (context) =>
            const StoreProductsEditScreen(),
        storeSettingsScreenRoute: (context) => const StoreSettingsScreen(),
        storeEditProductScreenRoute: (context) =>
            const StoreEditProductScreen(),
        driverMainScreenRoute: (context) => const DriverMainScreen(),
        driverDeliverListScreenRoute: (context) =>
            const DriverDeliverListScreen(),
        driverPaymentsScreenRoute: (context) => const DriverPaymentsScreen(),
        driverSettingsScreenRoute: (context) => const DriverSettingsScreen(),
      },
    );
  }
}
