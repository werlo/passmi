import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';
import 'package:passmi/models/item.dart';
import 'package:passmi/models/itemField.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class DbHelper {
  var logger = Logger();

  factory DbHelper() {
    _dbHelper ??= DbHelper._createInstance();
    return _dbHelper;
  }

   DbHelper._createInstance();

  static DbHelper _dbHelper;

  Future<Database> openDB(String password, String dbName) async {
    final String path = await getDbPath(dbName);
    debugPrint("inside openDb dhHelper");
    Database db = await openDatabase(path, version: 1, password: password,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await createTable(db, Item.createTable);
      await createTable(db, ItemField.createTable);
    });
    logger.i(' In DbHelper.openDB fn -> opened db $db');
    return db;
  }

 

  Future<String> getDirectoryPath() async {
    Directory directory = await getApplicationDocumentsDirectory();

    final String path = directory.path + '/';

    logger.i(' In DbHelper.getDirectoryPath() -> path of directory is $path');
    return path;
  }

  Future<String> getDbPath(String dbName) async {
    String path = await getDirectoryPath();
    path = path + '$dbName.xxxdb';
    return path;
  }

  Future<void> createTable(Database db, String insertQuery) async {
    if (db != null) {
      await db.execute(insertQuery);
      logger.i('In dBHelper.createTable -> table create executed');
    } else {
      logger.wtf('db cannot be null');
      throw Exception;
    }
  }

  Future<int> insert(
      Database db, String tableName, Map<String, dynamic> values) async {
    final int rowId = await db.insert(tableName,  values);
    if (rowId == -1) {
      logger.wtf('Error in inserting values to $tableName');
      throw Exception;
    }
    logger.i(
        ' In DbHelper.insert() -> inserting in table $tableName  values -> $values');
    return rowId;
  }

  Future<void> update(
      Database db, String tableName, Map<String, dynamic> values,
      {String where, List<String> whereArgs}) async {
    final int rowId = await db.update(
        tableName,  values, where: where, whereArgs: whereArgs);
    if (rowId == -1) {
      logger.wtf('Error in updating values to $tableName');
      throw Exception;
    }
    logger.i(
        ' In DbHelper.update() -> updating in table $tableName  values -> $values');
  }

  Future<void> delete(Database db, String tableName,
      {String where, List<String> whereArgs}) async {
    final int rowId =
        await db.delete( tableName, where: where, whereArgs: whereArgs);
    if (rowId == -1) {
      logger.wtf('Error in deleting values to $tableName');
      throw Exception;
    }
    logger.i(' In DbHelper.delete() -> deleting in table $tableName ');
  }

  //test this method
  Future<List<Map<String, dynamic>>> getAllItem(
      Database db, String query) async {
    List<Map> rows = await db.rawQuery(query);
    logger.i(' In DbHelper.getAllItem() -> $rows');
    return rows;
  }

  // List<Map<String, dynamic>> getMapList(SQLiteCursor rows) {
  //   List<Map<String, dynamic>> result = [];
  //   for (Map<String, dynamic> row in rows) {
  //     result.add(row);
  //     logger.wtf('adding db row to map , row -> $row');
  //   }
  //   return result;
  // }
}


 // Future<Database> createAndOpenDB(String dbName) async {
  //   final String path = await getDbPath(dbName);
  //   Database db = await Database.openOrCreateDatabase(path, password: password);
  //   createTable(db, Item.createTable);
  //   createTable(db, ItemField.createTable);
  //   logger.i(' In DbHelper.createAndOpenDB fn -> created table and db $db');
  //   return db;
  // }