import 'dart:convert';
import 'dart:developer';

import 'package:photoshop/model/content.dart';
import 'package:photoshop/model/photoshop.dart';
import 'package:sqflite/sqflite.dart' as sql;

class Database {
  static late sql.Database _db;
  static Future<void> createdb() async {
    String path = await sql.getDatabasesPath();
    String actualpath = path + "photoshop.db";
    _db =
        await sql.openDatabase(actualpath, onCreate: _createtable, version: 1);
  }

  static Future<void> _createtable(sql.Database database, int version) async {
    String sql = '''create table if not exists photoshops
        (id INTEGER primary key AUTOINCREMENT,
        created_at DEFAULT CURRENT_TIMESTAMP,
        background TEXT ,
        photoshopContent TEXT        )''';
    await database
        .execute(sql)
        .then((value) => log("successfully generated table photoshops"));
  }

  static Future<int> save(Photoshop photoshop, String backgroundimage) async {
    List<Map<String, dynamic>> datas =
        photoshop.contents.map((e) => e.tojson()).toList(growable: true);
    final String photoshopContent = json.encode(datas);
    Map<String, dynamic> values = {
      "photoshopContent": photoshopContent,
      "background": backgroundimage
    };
    int outputindex = await _db.insert("photoshops", values);
    photoshop.id = outputindex;
    return outputindex;
  }

  static Future<List<Photoshop>> read() async {
    List<Map<String, Object?>> photoshopsdata = await _db.query("photoshops");

    List<Photoshop> photoshops = photoshopsdata.map((map) {
      int id = map["id"] as int;
      DateTime lasEdit = DateTime.parse(map["created_at"].toString());
      String background = map["background"].toString();
      List<dynamic> decodedData =
          json.decode(map["photoshopContent"].toString());

      // log(Content.fromjson(decodedData.first).tojson().toString());
      return Photoshop(
          contents: decodedData.map((e) => Content.fromjson(e)).toList(),
          id: id,
          lasEdit: lasEdit,
          background: background);
    }).toList();
    // log(photoshops.last.id.toString());
    return photoshops.isEmpty ? [] : photoshops;
  }

  static Future<int> delete(int id) async {
    String sql = "delete from photoshops where id=?";
    int deletedindex = await _db.rawDelete(sql, [id]);
    return deletedindex;
  }

  static Future<Photoshop?> getPhotoshop(int id) async {
    String sql = "select * from photoshops where id=?";
    List<Map<String, dynamic>> datas = await _db.rawQuery(sql, [id]);
    if (datas.isEmpty) return null;
    Map<String, dynamic> map = datas.first;
    DateTime lasEdit = DateTime.parse(map["created_at"].toString());
    String background = map["background"].toString();
    List<dynamic> decodedData = json.decode(map["photoshopContent"].toString());
    return Photoshop(
        contents: decodedData.map((e) => Content.fromjson(e)).toList(),
        id: id,
        lasEdit: lasEdit,
        background: background);
  }

  static Future<int> update(Photoshop photoshop, int id) async {
    List<Map<String, dynamic>> datas =
        photoshop.contents.map((e) => e.tojson()).toList(growable: true);
    final String photoshopContent = json.encode(datas);
    Map<String, dynamic> values = {
      "background": photoshop.background,
      "photoshopContent": photoshopContent,
    };
    int idupdated =
        await _db.update("photoshops", values, where: "id=?", whereArgs: [id]);
    return idupdated;
  }

  static Future<void> close() async {
    _db.isOpen ? await _db.close() : null;
  }
}
