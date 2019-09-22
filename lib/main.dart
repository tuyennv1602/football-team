import 'package:flutter/material.dart';
import 'package:myfootball/blocs/app-bloc.dart';
import 'package:myfootball/blocs/base-bloc.dart';
import 'package:myfootball/data/app-preference.dart';
import 'package:myfootball/provider_setup.dart' as setupProvider;
import 'package:myfootball/ui/pages/home-page.dart';
import 'package:myfootball/ui/pages/login/login-page.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:myfootball/utils/local-timeago.dart';
import 'package:provider/provider.dart';
import 'http.dart'; // make dio as global top-level variable
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
  var token = await AppPreference().getToken();
  dio.interceptors
    ..add(LogInterceptor(
        responseBody: true, requestBody: true, responseHeader: false));
  (dio.transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
  return runApp(BlocProvider<AppBloc>(
    bloc: AppBloc(),
    child: MyApp(token != null),
  ));
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
        theme: ThemeData(
          canvasColor: Colors.transparent,
          fontFamily: 'regular',
        ),
        home: _isLogined ? HomePage() : LoginPage(),
      ),
    );
  }
}
