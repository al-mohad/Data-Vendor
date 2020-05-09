import 'dart:io';

import 'package:datavendor/models/data.dart';
import 'package:datavendor/models/profile_model.dart';
import 'package:datavendor/models/settings_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database _database;
  DatabaseHelper._();

  factory DatabaseHelper() {
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
    db.execute('''
    CREATE TABLE settings(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      isp_name TEXT,
      isp_number TEXT,
      isp_pin TEXT)
  ''');
    db.execute('''
    CREATE TABLE profile(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT,
      imgUrl TEXT)
  ''');
    print("Database was created!");
    insertDefaultSettings();
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    // Run migration according database versions
  }
  Future insertDefaultSettings() async {
    var client = await db;
    client.rawInsert(
        'INSERT INTO settings(isp_name, isp_number, isp_pin) VALUES("AIRTEL", "121", "1122")');
    client.rawInsert(
        'INSERT INTO settings(isp_name, isp_number, isp_pin) VALUES("ETISALAT", "222", "1122")');
    client.rawInsert(
        'INSERT INTO settings(isp_name, isp_number, isp_pin) VALUES("GLO", "127", "1122")');
    client.rawInsert(
        'INSERT INTO settings(isp_name, isp_number, isp_pin) VALUES("MTN", "131", "1122")');
    client.rawInsert(
        'INSERT INTO profile(username, imgUrl) VALUES("Almohad", "www.google.com/me")');
    client.rawInsert(
        'INSERT INTO profile(username, imgUrl) VALUES("Hacker", "www.google.com/me")');
  }

  Future<List<Data>> fetchAll() async {
    var client = await db;
    var res = await client.query('dataVendor', orderBy: 'phone_number ASC');

    if (res.isNotEmpty) {
      var datas = res.map((datasMap) => Data.fromDb(datasMap)).toList();
      return datas;
    }
    return [];
  }

  Future<List<Settings>> fetchSettings() async {
    var client = await db;
    var res = await client.query('settings');

    if (res.isNotEmpty) {
      var datas = res.map((datasMap) => Settings.fromDb(datasMap)).toList();
      return datas;
    }
    return [];
  }

  Future<List<Profile>> fetchProfile() async {
    var client = await db;
    var res = await client.query('profile');

    if (res.isNotEmpty) {
      var datas = res.map((datasMap) => Profile.fromDb(datasMap)).toList();
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

  Future<int> updatePINCODE(String new_pin, String id) async {
    var client = await db;
    client.rawUpdate(
        'UPDATE settings SET isp_pin = ? WHERE id = ?', ['$new_pin', '$id']);
  }

  Future<int> updateUsername(String new_username, String id) async {
    var client = await db;
    client.rawUpdate('UPDATE profile SET username = ? WHERE id = ?',
        ['$new_username', '$id']);
  }

  Future<String> updateISP(String new_isp_pin, String id) async {
    var client = await db;
    client.rawUpdate('UPDATE settings SET isp_pin = ? WHERE id = ?',
        ['$new_isp_pin', '$id']);
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
