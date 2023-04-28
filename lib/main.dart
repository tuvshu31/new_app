import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/local_notification.dart';
import 'package:Erdenet24/api/navigation.dart';
import 'package:Erdenet24/api/notification.dart';
import 'package:Erdenet24/api/notifications.dart';
import 'package:Erdenet24/controller/user_controller.dart';
import 'package:Erdenet24/screens/driver/driver_deliver_list_screen.dart';
import 'package:Erdenet24/screens/driver/driver_payments_screen.dart';
import 'package:Erdenet24/screens/driver/driver_settings_screen.dart';
import 'package:Erdenet24/screens/splash/splash_main_screen.dart';
import 'package:Erdenet24/screens/splash/splash_otp_screen.dart';
import 'package:Erdenet24/screens/splash/splash_phone_register_screen.dart';
import 'package:Erdenet24/screens/splash/splash_privacy_policy_screen.dart';
import 'package:Erdenet24/screens/splash/splash_prominent_disclosure_screen.dart';
import 'package:Erdenet24/screens/store/store_main_screen.dart';
import 'package:Erdenet24/screens/store/store_orders_screen.dart';
import 'package:Erdenet24/screens/store/store_products_create_product_screen.dart';
import 'package:Erdenet24/screens/store/store_products_edit_main_screen.dart';
import 'package:Erdenet24/screens/store/store_products_edit_product_screen.dart';
import 'package:Erdenet24/screens/store/store_products_preview_screen.dart';
import 'package:Erdenet24/screens/store/store_settings_screen.dart';
import 'package:Erdenet24/screens/user/user_category_products_screen.dart';
import 'package:Erdenet24/screens/user/user_home_screen.dart';
import 'package:Erdenet24/screens/user/user_navigation_drawer_screen.dart';
import 'package:Erdenet24/screens/user/user_order_payment_screen.dart';
import 'package:Erdenet24/screens/user/user_orders_active_screen.dart';
import 'package:Erdenet24/screens/user/user_profile_address_edit_screen.dart';
import 'package:Erdenet24/screens/user/user_profile_help_screen.dart';
import 'package:Erdenet24/screens/user/user_profile_orders_screen.dart';
import 'package:Erdenet24/screens/user/user_profile_phone_edit_screen.dart';
import 'package:Erdenet24/screens/user/user_profile_screen.dart';
import 'package:Erdenet24/screens/user/user_qr_scan_screen.dart';
import 'package:Erdenet24/screens/user/user_saved_screen.dart';
import 'package:Erdenet24/screens/user/user_search_screen.dart';
import 'package:Erdenet24/screens/user/user_store_list_screen.dart';
import 'package:Erdenet24/screens/user/user_store_products_screen.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:geolocator_apple/geolocator_apple.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/cart_controller.dart';
import 'package:Erdenet24/controller/login_controller.dart';
import 'package:Erdenet24/controller/product_controller.dart';
import 'package:Erdenet24/screens/driver/driver_main_screen.dart';
import 'package:Erdenet24/screens/user/user_cart_screen.dart';
import 'package:Erdenet24/screens/user/user_subcategory_products_screen.dart';
import 'package:Erdenet24/screens/user/user_products_screen.dart';
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
  handleNotifications(message, true);
}

Future<void> _firebaseMessagingForegroundHandler(RemoteMessage message) async {
  log(message.data.toString());
  handleNotifications(message, true);
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: "Main Navigator");

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  RestApiHelper.authBox = await Hive.openBox('myBox');
  if (Platform.isAndroid) {
    GeolocatorAndroid.registerWith();
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
  //Huudas shiljiheer ondelete hiigdeed bga blhoor eniig duudaj bga. Ustgaj bolohgui
  final cartCtrl = Get.put(CartController(), permanent: true);
  final loginCtrl = Get.put(LoginController(), permanent: true);
  final productCtrl = Get.put(ProductController(), permanent: true);
  final _loginCtx = Get.put(LoginController());
  final _userCtx = Get.put(UserController());
  //Login hiisen hereglegchiin token.g database deer hadgalj avah
  @override
  void initState() {
    super.initState();
    _loginCtx.checkVersion(context);
    // NotificationController.askNotificationPermission();
    // NotificationController.setNotificationListeners();
    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_firebaseMessagingForegroundHandler);
    FirebaseMessaging.onMessageOpenedApp
        .listen(_firebaseMessagingBackgroundHandler);
    Noti.initialize(flutterLocalNotificationsPlugin);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      title: "Erdenet24",
      initialRoute: splashMainScreenRoute,
      // defaultTransition: Transition.,
      theme: ThemeData(fontFamily: 'Nunito'),
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
        userCategoryProductsScreenRoute: (context) =>
            const UserCategoryProductScreen(),
        userNavigationDrawerScreenRoute: (context) =>
            const UserNavigationDrawerScreen(),
        userCartAddressInfoScreenRoute: (context) =>
            const UserCartAddressInfoScreen(),
        userOrderPaymentScreenRoute: (context) =>
            const UserOrderPaymentScreen(),
        userOrdersActiveScreenRoute: (context) => const UserOrderActiveScreen(),
        userProductScreenRoute: (context) => const UserProductScreen(),
        userProfileAddressEditScreenRoute: (context) =>
            const UserProfileAddressEditScreen(),
        userProfileHelpScreenRoute: (context) => const UserProfileHelpScreen(),
        userProfileOrdersScreenRoute: (context) =>
            const UserProfileOrdersScreen(),
        userProfilePhoneEditScreenRoute: (context) =>
            const UserProfilePhoneEditScreen(),
        userProfileScreenRoute: (context) => const UserProfileScreen(),
        userQrScanScreenRoute: (context) => const UserQRScanScreen(),
        userSavedScreenRoute: (context) => const UserSavedScreen(),
        userSearchMainScreenRoute: (context) => const UserSearchMainScreen(),
        userSearchScreenRoute: (context) => const UserSearchScreen(),
        userStoreListScreenRoute: (context) => const UserStoreListScreen(),
        userStoreProductsScreenRoute: (context) => const UserStoreProducts(),
        userSubCategoryProductsScreenRoute: (context) =>
            const UserSubCategoryProductsScreen(),
        storeMainScreenRoute: (context) => const StoreMainScreen(),
        storeOrdersScreenRoute: (context) => const StoreOrdersScreen(),
        storeProductsCreateProductScreenRoute: (context) =>
            const StoreProductsCreateProductScreen(),
        storeProductsEditMainScreenRoute: (context) =>
            const StoreProductsEditMainScreen(),
        storeProductsEditProductRoute: (context) =>
            const StoreProductsEditProductScreen(),
        storeProductsPreviewScreenRoute: (context) =>
            const StoreProductsPreviewScreen(),
        storeSettingsScreenRoute: (context) => const StoreSettingsScreen(),
        driverMainScreenRoute: (context) => const DriverMainScreen(),
        driverDeliverListScreenRoute: (context) =>
            const DriverDeliverListScreen(),
        driverPaymentsScreenRoute: (context) => const DriverPaymentsScreen(),
        driverSettingsScreenRoute: (context) => const DriverSettingsScreen(),
      },
    );
  }
}
