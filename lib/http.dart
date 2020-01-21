import 'package:dio/dio.dart';

var dio = new Dio(
  BaseOptions(
    connectTimeout: 30000,
    receiveTimeout: 30000,
    contentType: 'application/json; charset=utf-8',
    baseUrl: 'http://35.240.169.217:8080/football/',
  )
);