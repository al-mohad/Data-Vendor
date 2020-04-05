import 'dart:io';

import 'package:datavendor/models/data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DataHelper {
  static final DataHelper _instance = DataHelper._();
  static Database _database;
  DataHelper._();

  factory DataHelper() {
    return _instance;
  }

  Future<Database> get db async {
    if (_database != null) {
      return _database;
    }
    _database = await init();

    return _database;
  }

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = directory.path + 'database.db';
    var database = openDatabase(dbPath,
        version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return database;
  }

  void _onCreate(Database db, int version) {
    db.execute('''
    CREATE TABLE dataVendor(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      phone_number TEXT,
      data_amount TEXT,
      date_sent TEXT,
      time_sent TEXT)
  ''');
    print("Database was created!");
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    // Run migration according database versions
  }

  Future<List<Data>> fetchAll() async {
    var client = await db;
    var res = await client.query('dataVendor');

    if (res.isNotEmpty) {
      var datas = res.map((datasMap) => Data.fromDb(datasMap)).toList();
      return datas;
    }
    return [];
  }

  Future<int> addRecord(Data data) async {
    var client = await db;
    return client.insert('dataVendor', data.toMapForDb(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Data> fetchRecord(int id) async {
    var client = await db;
    final Future<List<Map<String, dynamic>>> futureMaps =
        client.query('dataVendor', where: 'id = ?', whereArgs: [id]);
    var maps = await futureMaps;
    if (maps.length != 0) {
      return Data.fromDb(maps.first);
    }
    return null;
  }

  Future<int> updateRecord(Data data) async {
    var client = await db;
    return client.update('dataVendor', data.toMapForDb(),
        where: 'id = ?',
        whereArgs: [data.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeRecord(int id) async {
    var client = await db;
    return client.delete('dataVendor', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteRecord(int id) async {
    Database client = await db;
    var result =
        await client.rawDelete("DELETE FROM dataVendor where id = $id");
    return result;
  }

  Future closeDb() async {
    var client = await db;
    client.close();
  }
}
