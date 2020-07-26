import 'dart:io' as io;
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:passmi/models/item.dart';
import 'package:passmi/models/itemField.dart';
import 'package:passmi/utils/basic_constants.dart';
import 'package:passmi/utils/dbhelper.dart';
import 'package:logger/logger.dart';

class CoreService {
  var logger = Logger();

  factory CoreService() {
    _coreService ??= CoreService._createInstance();
    return _coreService;
  }

  CoreService._createInstance();
  static CoreService _coreService;

  static CoreService get coreService => _coreService;

  static set coreService(CoreService value) {
    _coreService = value;
  } //can remove this if static issue

  final DbHelper dbHelper = DbHelper();
  Database _dbInstance;

  Database get dbInstance => _dbInstance;

  set dbInstance(Database value) {
    _dbInstance = value;
  }

  Future<bool> checkIfFirstTimeUser() async {
    final String path = await dbHelper.getDbPath(Constants.dbName);
    final bool isExist = await io.File(path).exists();
    return !isExist;
  }

  Future<Database> openDB(String password) async {
    _dbInstance ??= await dbHelper.openDB(password, Constants.dbName);
    return _dbInstance;
  }

  // Future<Database> getOrCreateDb(String password) async {
  //   _dbInstance ??= await dbHelper.createAndOpenDB(password, Constants.dbName);
  //   return _dbInstance;
  // }

  Future<List<Item>> getAllItem() async {
    List<Map<String, dynamic>> itemMapList =
        await dbHelper.getAllItem(_dbInstance, Item.fetchQuery);
    List<Item> itemList = [];
    itemMapList.forEach((el) {
      itemList.add(Item.fromJson(el));
    });
    return itemList;
  }

  Future<List<ItemField>> getItemFields(Item current) async {
    String id = current.id.toString();
    final String colItemId = ItemField.colItemId;
    List<Map<String, dynamic>> mapList = await _dbInstance
        .query(ItemField.tableName, where: '$colItemId=?', whereArgs: [id]);
    List<ItemField> fields = [];
    mapList.forEach((el) {
      fields.add(ItemField.fromJson(el));
    });
    return fields;
  }

  Future<void> insertItem(Item current) async {
    final int id =
        await dbHelper.insert(_dbInstance, Item.tableName, current.toJson());
    logger.i("ItemId: $id");
    current.itemFields.forEach((el) async {
      el.itemId = id;
      final int itemFieldId = await insertItemField(el);
      logger.i('id of inserted itemfield $itemFieldId');
    });
  }

  Future<int> insertItemField(ItemField itemField) async {
    return await dbHelper.insert(
        _dbInstance, ItemField.tableName, itemField.toJson());
  }

  Future<void> updateItem(Item current) async {
    String id = current.id.toString();
    final String colItemId = Item.colId;
    return await dbHelper.update(_dbInstance, Item.tableName, current.toJson(),
        where: '$colItemId=?', whereArgs: [id]);
  }

  Future<void> updateItemField(ItemField current) async {
    String id = current.id.toString();
    final String colItemId = ItemField.colId;
    return await dbHelper.update(
        _dbInstance, ItemField.tableName, current.toJson(),
        where: '$colItemId=?', whereArgs: [id]);
  }

  Future<void> deleteItem(Item current) async {
    String id = current.id.toString();
    final String colItemId = Item.colId;
    return await dbHelper.delete(_dbInstance, Item.tableName,
        where: '$colItemId=?', whereArgs: [id]);
  }

  Future<void> deleteItemField(ItemField current) async {
    String id = current.id.toString();
    final String colItemId = ItemField.colItemId;
    return await dbHelper.delete(_dbInstance, ItemField.tableName,
        where: '$colItemId=?', whereArgs: [id]);
  }

  Future<void> updateItemInDatabase(
      Item mainItem,
      List<ItemField> newAddedField,
      List<ItemField> updatedFields,
      List<ItemField> deletedFields) async {
    updateItem(mainItem);
    if (newAddedField.isNotEmpty) {
      newAddedField.forEach((el) async {
        el.itemId = mainItem.id;
        final int itemFieldId = await insertItemField(el);
        logger.i('id of inserted itemfield $itemFieldId');
      });
    }
    if (updatedFields.isNotEmpty) {
      updatedFields.forEach((el) async {
        await updateItemField(el);
      });
    }
    if (deletedFields.isNotEmpty) {
      deletedFields.forEach((el) async {
        await deleteItemField(el);
      });
    }
  }
}
