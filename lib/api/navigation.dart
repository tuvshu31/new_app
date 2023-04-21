import 'package:flutter/material.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  navigateTo(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState
        ?.pushNamed(routeName, arguments: arguments);
  }

  pop(value) {
    return navigatorKey.currentState?.pop(value);
  }

  goBack() {
    return navigatorKey.currentState?.pop();
  }

  popUntil(String desiredRoute) {
    return navigatorKey.currentState?.popUntil((route) {
      return route.settings.name == desiredRoute;
    });
  }

  pushNamedAndRemoveUntil(route, popToInitial) {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(
      route,
      (Route<dynamic> route) => popToInitial,
    );
  }

  pushReplacementNamed(String desiredRoute, {dynamic arguments}) {
    return navigatorKey.currentState!
        .pushReplacementNamed(desiredRoute, arguments: arguments);
  }

  BuildContext getNavigationContext() {
    return navigatorKey.currentState!.context;
  }
}
