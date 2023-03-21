//Splash screen routes
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:flutter/services.dart';

const String splashMainScreenRoute = '/splashMainScreenRoute';
const String splashOtpScreenRoute = '/splashOtpScreenRoute';
const String splashPhoneRegisterScreenRoute = '/splashPhoneRegisterScreenRoute';
//User screen routes
const String userCartAddressInfoScreenRoute = '/userCartAddressInfoScreen';
const String userCartScreenRoute = '/userCartScreen';
const String userCategoryProductsScreenRoute = '/userCategoryProductsScreen';
const String userHomeScreenRoute = '/userHomeScreen';
const String userNavigationDrawerScreenRoute =
    '/userNavigationDrawerScreenRoute';
const String userOrderPaymentScreenRoute = '/userOrderPaymentScreenRoute';
const String userOrdersActiveScreenRoute = '/userOrdersActiveScreenRoute';
const String userProductScreenRoute = '/userProductScreenRoute';
const String userProfileAddressEditScreenRoute =
    '/userProfileAddressEditScreenRoute';
const String userProfileHelpScreenRoute = '/userProfileHelpScreenRoute';
const String userProfileOrdersScreenRoute = '/userProfileOrdersScreenRoute';
const String userProfilePhoneEditScreenRoute =
    '/userProfilePhoneEditScreenRoute';
const String userProfileScreenRoute = '/userProfileScreenRoute';
const String userQrScanScreenRoute = '/userQrScanScreenRoute';
const String userSavedScreenRoute = '/userSavedScreenRoute';
const String userSearchMainScreenRoute = '/userSearchMainScreenRoute';
const String userSearchScreenRoute = '/userSearchScreenRoute';
const String userStoreListScreenRoute = '/userStoreListScreenRoute';
const String userStoreProductsScreenRoute = '/userStoreProductsScreenRoute';
const String userSubCategoryProductsScreenRoute =
    '/userSubCategoryProductsScreenRoute';
//Store screen routes
const String storeMainScreenRoute = '/storeMainScreenRoute';
const String storeOrdersScreenRoute = '/storeOrdersScreenRoute';
const String storeProductsCreateProductScreenRoute =
    '/storeProductsCreateProductScreenRoute';
const String storeProductsEditMainScreenRoute =
    '/storeProductsEditMainScreenRoute';
const String storeProductsEditProductRoute = '/storeProductsEditProductRoute';
const String storeProductsPreviewScreenRoute =
    '/storeProductsPreviewScreenRoute';
const String storeSettingsScreenRoute = '/storeSettingsScreenRoute';
//Driver screen routes
const String driverMainScreenRoute = '/driverMainScreenRoute';
const String driverDrawerScreenRoute = '/driverDrawerScreenRoute';
const String driverDeliverListScreenRoute = '/driverDeliverListScreenRoute';
const String driverPaymentsScreenRoute = '/driverPaymentsScreenRoute';
const String driverSettingsScreenRoute = '/driverSettingsScreenRoute';

initialRoute() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then(
    (value) {
      if (RestApiHelper.getUserId() == 0) {
        splashMainScreenRoute;
      } else if (RestApiHelper.getUserRole() == "store") {
        storeMainScreenRoute;
      } else if (RestApiHelper.getUserRole() == "driver") {
        driverMainScreenRoute;
      } else if (RestApiHelper.getUserRole() == "user") {
        if (RestApiHelper.getOrderId() != 0) {
          userOrdersActiveScreenRoute;
        } else {
          userHomeScreenRoute;
        }
      } else {
        splashMainScreenRoute;
      }
    },
  );
}
