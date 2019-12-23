import 'package:flutter/material.dart';

class Navigation {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static final Navigation _instance = Navigation.internal();

  factory Navigation() => _instance;

  Navigation.internal();

  static Navigation get instance {
    if (_instance == null) {
      return Navigation();
    }
    return _instance;
  }

  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) async {
    return await navigatorKey.currentState
        .pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> navigateAndRemove(String routeName,
      {dynamic arguments}) async {
    return await navigatorKey.currentState
        .pushNamedAndRemoveUntil(routeName, (Route<dynamic> route) => false);
  }

  bool goBack({dynamic result}) {
    return navigatorKey.currentState.pop(result);
  }
}
