import 'item.dart';
// Class ItemField

class ItemField {
  int id;
  int itemId;
  String fieldTitle;
  String fieldType;
  String fieldValue;
  int sensitive;
  int createdAt;
  int updatedAt;

  static const String tableName = 'T_ItemField';
  static const String colId = 'field_id';
  static const String colItemId = Item.colId;
  static const String colTitle = 'field_title';
  static const String colType = 'field_type';
  static const String colValue = 'field_value';
  static const String colSensitive = 'field_sensitive';
  static const String colCreatedAt = 'field_createdAt';
  static const String colUpdatedAt = 'field_updatedAt';
  static const String ItemTableName = Item.tableName;
  static const String createTable = """ 
     CREATE TABLE IF NOT EXISTS $tableName (
   $colId INTEGER PRIMARY KEY AUTOINCREMENT,    
   $colTitle TEXT NOT NULL,
   $colType TEXT,
   $colValue TEXT,
   $colSensitive INTEGER,
   $colCreatedAt INTEGER,
   $colUpdatedAt INTEGER,
   $colItemId INTEGER NOT NULL,
   FOREIGN KEY ($colItemId)
      REFERENCES $ItemTableName ($colItemId)
      ON UPDATE CASCADE
      ON DELETE CASCADE
   )""";

  createItemFieldFromUI(String fieldTitle, String value, {bool isSensitive}) {
    this.id = null;
    this.itemId = null;
    this.fieldTitle = fieldTitle;
    this.fieldType = "";
    this.fieldValue = value;
    this.sensitive = isSensitive ? isSensitive : 0;
    this.createdAt = DateTime.now().millisecondsSinceEpoch;
    this.updatedAt = DateTime.now().millisecondsSinceEpoch;
  }

  updateItemField(ItemField currentItemField, String newValue) {
    currentItemField.fieldValue = newValue;
    currentItemField.updatedAt = DateTime.now().millisecondsSinceEpoch;
  }

  ItemField(
      {this.id,
      this.itemId,
      this.fieldTitle,
      this.fieldType,
      this.fieldValue,
      this.sensitive,
      this.createdAt,
      this.updatedAt});

  ItemField.fromJson(Map<String, dynamic> json) {
    id = json[ItemField.colId];
    itemId = json[ItemField.colItemId];
    fieldTitle = json[ItemField.colTitle];
    fieldType = json[ItemField.colType];
    fieldValue = json[ItemField.colValue];
    sensitive = json[ItemField.colSensitive];
    createdAt = json[ItemField.colCreatedAt];
    updatedAt = json[ItemField.colUpdatedAt];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[ItemField.colId] = this.id;
    data[ItemField.colItemId] = this.itemId;
    data[ItemField.colTitle] = this.fieldTitle;
    data[ItemField.colType] = this.fieldType;
    data[ItemField.colValue] = this.fieldValue;
    data[ItemField.colSensitive] = this.sensitive;
    data[ItemField.colCreatedAt] = this.createdAt;
    data[ItemField.colUpdatedAt] = this.updatedAt;
    return data;
  }
}
