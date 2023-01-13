import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/cart_controller.dart';
import 'package:Erdenet24/controller/login_controller.dart';
import 'package:Erdenet24/controller/product_controller.dart';
import 'package:Erdenet24/screens/splash/splash_screen.dart';
import 'package:Erdenet24/screens/store/store.dart';
import 'package:Erdenet24/screens/user/cart/cart_screen.dart';
import 'package:Erdenet24/screens/user/home/category_products.dart';
import 'package:Erdenet24/screens/user/home/home.dart';
import 'package:Erdenet24/screens/user/home/subcategory_products.dart';
import 'package:Erdenet24/screens/user/home/product_screen.dart';
import 'package:Erdenet24/screens/user/home/search_screen.dart';
import 'package:Erdenet24/screens/user/order/order.dart';
import 'package:Erdenet24/screens/user/profile/user/user_settings.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Only call clearSavedSettings() during testing to reset internal values.
  await Upgrader.clearSavedSettings(); // REMOVE this for release builds
  await Hive.initFlutter();
  RestApiHelper.authBox = await Hive.openBox('myBox');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

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
    super.initState();
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
      title: "Erdenet24",
      initialRoute: "/",
      // defaultTransition: Transition.,
      theme: ThemeData(fontFamily: 'Nunito'),
      getPages: [
        GetPage(
            name: "/",
            page: () => RestApiHelper.getUserId() == 0
                ? const SplashScreen()
                : RestApiHelper.getUserRole() == "store"
                    ? const StorePage()
                    : RestApiHelper.getUserRole() == "user"
                        ? const MainScreen()
                        : const SplashScreen()),
        GetPage(name: "/UserSettingsRoute", page: () => const UserSettings()),
        GetPage(name: "/CartRoute", page: () => const CartScreen()),
        GetPage(name: "/CategoryRoute", page: () => const CategoryProducts()),
        GetPage(name: "/MainScreen", page: () => const MainScreen()),
        GetPage(
            name: "/CategoryNoTabbar", page: () => const SubCategoryProducts()),
        GetPage(name: "/ProductsRoute", page: () => const ProductScreenNew()),
        GetPage(name: "/SearchRoute", page: () => const SearchScreenMain()),
        GetPage(name: "/OrdersRoute", page: () => const Order()),
      ],
    );
  }
}
