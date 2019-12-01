import 'dart:io';

import 'package:dio/dio.dart';

var dio = new Dio(
  BaseOptions(
    connectTimeout: 30000,
    receiveTimeout: 30000,
    contentType: ContentType.json,
    baseUrl: 'http://34.70.102.151:8080/football/'
  )
);