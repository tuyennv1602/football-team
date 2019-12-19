import 'package:flutter/material.dart';
import 'package:myfootball/provider_setup.dart' as setupProvider;
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/fonts.dart';
import 'package:myfootball/service/local_storage.dart';
import 'package:myfootball/router/navigation.dart';
import 'package:myfootball/view/page/home_page.dart';
import 'package:myfootball/view/page/login/login_page.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:myfootball/router/router.dart';
import 'package:myfootball/utils/local_timeago.dart';
import 'package:provider/provider.dart';
import 'http.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:firebase_messaging/firebase_messaging.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

// Must be top-level function
_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

void main() async {
  timeago.setLocaleMessages('vi', ViMessage());
  _firebaseMessaging.requestNotificationPermissions();
  var token = await LocalStorage().getToken();
  dio.interceptors
    ..add(LogInterceptor(
        responseBody: true, requestBody: true, responseHeader: false));
  (dio.transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
  return runApp(MyApp(token != null));
}

class MyApp extends StatelessWidget {
  final bool _isLogined;

  MyApp(this._isLogined);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: setupProvider.providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: Navigation().navigatorKey,
        onGenerateRoute: generateRoute,
        theme: ThemeData(
          canvasColor: Colors.transparent,
          primaryColor: PRIMARY,
          accentColor: PRIMARY,
          fontFamily: REGULAR,
          accentIconTheme: IconThemeData(color: Colors.white)
        ),
        home: _isLogined ? HomePage() : LoginPage(),
      ),
    );
  }
}
