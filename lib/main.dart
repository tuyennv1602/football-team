import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:myfootball/blocs/app-bloc.dart';
import 'package:myfootball/blocs/base-bloc.dart';
import 'package:myfootball/blocs/login-bloc.dart';
import 'package:myfootball/data/app-preference.dart';
import 'package:myfootball/ui/pages/home-page.dart';
import 'package:myfootball/ui/pages/login/login-page.dart';
import 'dart:convert';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'http.dart'; // make dio as global top-level variable

// Must be top-level function
_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

void main() async {
  await FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
  await FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
  var token = await AppPreference().getToken();
  dio.interceptors..add(CookieManager(CookieJar()))..add(LogInterceptor(responseBody: true, requestBody: true, responseHeader: false, requestHeader: true));
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
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          canvasColor: Colors.transparent,
          textTheme: Theme.of(context).textTheme.copyWith(
              title: TextStyle(
                  fontFamily: 'semi-bold', fontSize: 18, letterSpacing: 0.1, color: Colors.white),
              body1: TextStyle(
                fontFamily: 'regular',
                fontSize: 14,
                letterSpacing: 0.1,
                color: Colors.black87,
              ),
              body2: TextStyle(
                  fontFamily: 'semi-bold',
                  fontSize: 16,
                  letterSpacing: 0.1,
                  color: Colors.white)),
        ),
        home: _isLogined
            ? HomePage()
            : BlocProvider<LoginBloc>(
                bloc: LoginBloc(),
                child: LoginPage(),
              ));
  }
}
