import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static final NavigationService _instance = NavigationService.internal();

  factory NavigationService() => _instance;

  NavigationService.internal();

  static NavigationService get instance {
    if (_instance == null) {
      return NavigationService();
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

  bool goBack() {
    return navigatorKey.currentState.pop();
  }
}
