import 'dart:developer';
import 'dart:io';
import 'package:Erdenet24/api/notifications.dart';
import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/screens/splash/splash_main_screen.dart';
import 'package:Erdenet24/screens/store/store_main_screen.dart';
import 'package:Erdenet24/screens/user/user_category_products_screen.dart';
import 'package:Erdenet24/screens/user/user_orders_active_screen.dart';
import 'package:Erdenet24/screens/user/user_profile_help_screen.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
import 'package:in_app_update/in_app_update.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:upgrader/upgrader.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final _driverCtx = Get.put(DriverController());
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1,
      channelKey: "basic_channel",
      title: "Erdenet24",
      body: "Шинэ захиалга ирлээ!",
      customSound: 'resource://raw/incoming',
      payload: message.data.map(
        (key, value) => MapEntry(
          key,
          value?.toString(),
        ),
      ),
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'SHOW_SERVICE_DETAILS',
        label: 'Show details',
        showInCompactView: true,
      )
    ],
  );

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: "basic_channel",
        channelName: "Basic Notification",
        channelDescription: "Notification channel for basic test",
        playSound: true,
        importance: NotificationImportance.High,
        soundSource: 'resource://raw/incoming',
      ),
    ],
    debug: true,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  log('User granted permission: ${settings.authorizationStatus}');

  // Only call clearSavedSettings() during testing to reset internal values.
  await Upgrader.clearSavedSettings(); // REMOVE this for release builds
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
  AppUpdateInfo? _updateInfo;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  //Huudas shiljiheer ondelete hiigdeed bga blhoor eniig duudaj bga. Ustgaj bolohgui
  final cartCtrl = Get.put(CartController(), permanent: true);
  final loginCtrl = Get.put(LoginController(), permanent: true);
  final productCtrl = Get.put(ProductController(), permanent: true);
  @override
  void initState() {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((allowed) {
      if (!allowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      } else {
        log("allowed");
      }
    });
    final newVersionPlus = NewVersionPlus(
      iOSId: 'mn.et24',
      androidId: 'mn.et24',
    );

    advancedStatusCheck(NewVersionPlus newVersion) async {
      print("Checking");
      final status = await newVersion.getVersionStatus();
      newVersionPlus.showUpdateDialog(
        context: context,
        versionStatus: status!,
        dialogTitle: 'Шинэчлэл хийнэ үү',
        dialogText:
            'Таны одоогийн хувилбар хуучирсан хувилбар тул шинэчлэл хийсний дараа ашиглах боломжтой.',
        updateButtonText: 'Шинэчлэл татах',
        dismissButtonText: 'Болих',
        allowDismissal: false,
      );
    }
  }

  // Future<void> checkForUpdate() async {
  //   _updateInfo?.updateAvailability == UpdateAvailability.updateAvailable
  //       ? () {
  //           InAppUpdate.performImmediateUpdate()
  //               .catchError((e) => showSnack(e.toString()));
  //         }
  //       : print("Updating");
  // }
  // Future<void> checkForUpdate() async {
  //   InAppUpdate.checkForUpdate().then((info) {
  //     info.updateAvailability == UpdateAvailability.updateAvailable
  //         ? InAppUpdate.performImmediateUpdate().catchError((e) {
  //             showSnack(e.toString());
  //           })
  //         : null;
  //   }).catchError((e) {
  //     showSnack(e.toString());
  //   });
  // }

  // void showSnack(String text) {
  //   if (_scaffoldKey.currentContext != null) {
  //     ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(SnackBar(
  //       dismissDirection: DismissDirection.none,
  //       content: CustomText(text: text),
  //     ));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: MyApp.navigatorKey,
      title: "Erdenet24",
      initialRoute: widget.initialRoute,
      // defaultTransition: Transition.,
      theme: ThemeData(fontFamily: 'Nunito'),
      getPages: [
        GetPage(name: "/", page: () => const StorePage()),
        GetPage(
            name: "/SplashScreenRoute", page: () => const SplashMainScreen()),
        GetPage(name: "/StoreScreenRoute", page: () => const StorePage()),
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
