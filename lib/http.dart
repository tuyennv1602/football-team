import 'package:dio/dio.dart';

var dio = new Dio(
  BaseOptions(
    connectTimeout: 60000,
    receiveTimeout: 60000
  )
);