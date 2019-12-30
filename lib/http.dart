import 'package:dio/dio.dart';

var dio = new Dio(
  BaseOptions(
    connectTimeout: 30000,
    receiveTimeout: 30000,
    contentType: 'application/json; charset=utf-8',
    baseUrl: 'http://34.70.102.151:8080/football/'
  )
);