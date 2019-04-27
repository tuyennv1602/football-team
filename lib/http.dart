import 'dart:io';

import 'package:dio/dio.dart';

var dio = new Dio(
  BaseOptions(
    connectTimeout: 30000,
    receiveTimeout: 30000,
    contentType: ContentType.json,
  )
);