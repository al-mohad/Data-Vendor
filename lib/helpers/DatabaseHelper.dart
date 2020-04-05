import 'dart:io';

import 'package:datavendor/models/send_data_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  //Create singleton database helper
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String TABLE = 'records';
  String ID = 'id';
  int newID;
  String PHONE_NUMBER = 'phone_number';
  String DATA_AMOUNT = 'data_amount';
  String DATE = 'date';
  String TIME_SENT = 'time_sent';

  //Named constructor to create to create instance of DatabaseHelper
  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    //Create database helper if and only if it's null
    if (_databaseHelper == null) {
      //This is executed only once, singleton object
      _databaseHelper = DatabaseHelper._createInstance();
    }
    _databaseHelper = DatabaseHelper._createInstance();
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    //Get the Directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'records.db';
    //Open/Create the database at a given path
    var recordDatabase =
        await openDatabase(path, version: 1, onCreate: _createdb);
    return recordDatabase;
  }

  _createdb(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($ID INTERGER PRIMARY KEY, $PHONE_NUMBER TEXT, $DATA_AMOUNT TEXT, $DATE TEXT, $TIME_SENT  TEXT)");
  }

  //Fetch Operations:
  Future<List<Map<String, dynamic>>> getRecordMapList() async {
    Database db = await this.database;
    //var result = await db.rawQuery("SELECT * FROM $TABLE order by $DATE ASC");
    var result = await db.query(TABLE, orderBy: '$DATE ASC');
    return result;
  }

  //Insert Operation:
  Future<int> insertRecord(SentDataInfo sendData) async {
    Database db = await this.database;
    var result = await db.insert(
      TABLE,
      sendData.toMap(),
    );
    return result;
  }

  //Update Operation:
  Future<int> updateRecord(SentDataInfo sendData) async {
    Database db = await this.database;
    var result = await db.update(TABLE, sendData.toMap(),
        where: '$ID=?', whereArgs: [sendData.id]);
    return result;
  }

  //Delete Operation:
  Future<int> deleteRecord(int id) async {
    Database db = await this.database;
    var result = await db.rawDelete("DELETE FROM $TABLE where $ID = $id");
    return result;
  }

  Future<int> getLastID() {}
  //Get number of records in database
  Future<int> getCount(SentDataInfo sendData) async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery("SELECT COUNT (*) FROM $TABLE");
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  //Get Map List and convert it to Sent Data List
  Future<List<SentDataInfo>> getRecordsList() async {
    var sentDataMapList = await getRecordMapList();
    int count = sentDataMapList.length;

    List<SentDataInfo> sentDataList = List<SentDataInfo>();

    for (int i = 0; i < count; i++) {
      sentDataList.add(SentDataInfo.fromMap(sentDataMapList[i]));
    }
    return sentDataList;
  }
}
