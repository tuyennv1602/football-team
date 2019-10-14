import 'package:flutter/services.dart';
import 'package:myfootball/models/district.dart';
import 'package:myfootball/models/province.dart';
import 'package:myfootball/models/ward.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class SQLiteServices {
  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    var directory = await getDatabasesPath();
    var path = join(directory, "region.db");
    bool isExist = await File(path).exists();
    if (!isExist) {
      print("Creating new copy from asset");
      ByteData data = await rootBundle.load("assets/data/region.db");
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
    } else {
      print("Opening existing database");
    }
    return await openDatabase(path);
  }

  Future<List<Province>> getProvinces() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT * from province');
    return result.map((item) => Province.fromJson(item)).toList();
  }

  Future<List<District>> getDistrictsByProvince(String provinceId) async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery('SELECT * from district WHERE province_id="$provinceId"');
    return result.map((item) => District.fromJson(item)).toList();
  }

  Future<List<Ward>> getWardsByDistrict(String districtId) async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery('SELECT * from ward WHERE district_id="$districtId"');
    return result.map((item) => Ward.fromJson(item)).toList();
  }
}
