// ignore_for_file: constant_identifier_names, avoid_print

import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:personal_finance/Database/create_acc_map.dart';
import 'package:personal_finance/Database/record_map.dart';
import 'package:sqflite/sqflite.dart';

class CreateDatabase {
  CreateDatabase._privateConstructor();
  static final CreateDatabase instance = CreateDatabase._privateConstructor();

  static Database? _db;

  static const String ACCOUNT_TABLE = 'Account';
  static const String RECORD_TABLE = 'Record';
  static const String RECORD_OUT_TABLE = 'RecordOut';
  static const String RECORD_SAV_TABLE = 'RecordSav';
  static const String DB_NAME = 'personalfinance.db';

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    print(">>>> path $path");
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE $ACCOUNT_TABLE (AutoID INTEGER PRIMARY KEY, name TEXT, phonenum INTEGER, password TEXT, image TEXT, checkZero TEXT)",
    );
    await db.execute(
      "CREATE TABLE $RECORD_TABLE (AutoID INTEGER PRIMARY KEY, record_date TEXT, record_price INTEGER, record_cat TEXT, record_remark TEXT , checkZero TEXT)",
    );
    await db.execute(
      "CREATE TABLE $RECORD_OUT_TABLE(AutoID INTEGER PRIMARY KEY, record_date TEXT, record_price INTEGER, record_cat TEXT, record_remark TEXT, checkZero TEXT)",
    );
    await db.execute(
        "CREATE TABLE $RECORD_SAV_TABLE(AutoID INTEGER PRIMARY KEY, record_date TEXT, record_remark TEXT, record_price INTEGER, checkZero TEXT)");
    print("CREATE TBL>>");
  }

  //// account
  Future<AccMap> createAcc(AccMap createAcc) async {
    Database? _db = await instance.db;
    createAcc.name = await _db?.insert(ACCOUNT_TABLE, createAcc.toMap());
    return createAcc;
  }

  Future<int> editAcc(AccMap acc, int id) async {
    var _db = await db;
    return await _db!.update(
      ACCOUNT_TABLE,
      acc.toMap(),
      where: 'AutoID= ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getAcc() async {
    Database? db = await instance.db;
    return await db!.query(ACCOUNT_TABLE);
  }

  Future<int> deleteAcc(int id) async {
    var _db = await db;
    return await _db!.delete(
      ACCOUNT_TABLE,
      where: 'AutoID = ?',
      whereArgs: [id],
    );
  }

  /// record
  Future<RecordMap> createRecord(RecordMap createRecord) async {
    Database? _db = await instance.db;
    createRecord.record_remark = await _db?.insert(
      RECORD_TABLE,
      createRecord.toMap(),
    );
    return createRecord;
  }

  Future<RecordMap> createRecordOut(RecordMap createRecordOut) async {
    Database? _db = await instance.db;
    createRecordOut.record_remark = await _db?.insert(
      RECORD_OUT_TABLE,
      createRecordOut.toMap(),
    );
    return createRecordOut;
  }

  Future<RecordMap> createRecordSav(RecordMap createRecordSav) async {
    Database? _db = await instance.db;
    createRecordSav.record_remark = await _db?.insert(
      RECORD_SAV_TABLE,
      createRecordSav.toMap(),
    );
    return createRecordSav;
  }

  Future<int> editRecord(RecordMap record, int id) async {
    var _db = await db;
    return await _db!.update(
      RECORD_TABLE,
      record.toMap(),
      where: 'AutoID= ?',
      whereArgs: [id],
    );
  }

  Future<int> editRecordOut(RecordMap recordOut, int id) async {
    var _db = await db;
    return await _db!.update(
      RECORD_OUT_TABLE,
      recordOut.toMap(),
      where: 'AutoID = ?',
      whereArgs: [id],
    );
  }

  Future<int> editRecordSav(RecordMap recordSav, int id) async {
    var _db = await db;
    return await _db!.update(
      RECORD_SAV_TABLE,
      recordSav.toMap(),
      where: 'AutoID = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getRecords() async {
    Database? db = await instance.db;
    return await db!.query(RECORD_TABLE);
  }

  Future<List<Map<String, dynamic>>> getRecordsOut() async {
    Database? db = await instance.db;
    return await db!.query(RECORD_OUT_TABLE);
  }

  Future<List<Map<String, dynamic>>> getRecordsSav() async {
    Database? db = await instance.db;
    return await db!.query(RECORD_SAV_TABLE);
  }

  Future<List<Map<String, dynamic>>> getRecord(int id) async {
    Database? db = await instance.db;
    return await db!.query(
      RECORD_TABLE,
      where: 'AutoID= ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getRecordOut(int id) async {
    Database? db = await instance.db;
    return await db!.query(
      RECORD_OUT_TABLE,
      where: 'AutoID = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getRecordSav(int id) async {
    Database? db = await instance.db;
    return await db!.query(
      RECORD_SAV_TABLE,
      where: 'AutoID = ?',
      whereArgs: [id],
    );
  }

  deleteRecord(int id) async {
    var _db = await db;
    return await _db!.delete(
      RECORD_TABLE,
      where: 'AutoID = ?',
      whereArgs: [id],
    );
  }

  deleteRecordOut(int id) async {
    var _db = await db;
    return await _db!.delete(
      RECORD_OUT_TABLE,
      where: 'AutoID = ?',
      whereArgs: [id],
    );
  }

  deleteRecordSav(int id) async {
    var _db = await db;
    return await _db!.delete(
      RECORD_SAV_TABLE,
      where: 'AutoID = ?',
      whereArgs: [id],
    );
  }

  //// remove db
  Future deleteDB() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    await deleteDatabase(path);
  }
}
