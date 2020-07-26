import 'itemField.dart';
// Class Item

class Item {
  int id;
  String title;
  String suggestionType;
  int favourite;
  int createdAt;
  int updatedAt;
  List<ItemField> itemFields;

  Item.createItemFromUI(String title, List<ItemField> itemFields) {
    this.id = null;
    this.title = title;
    this.favourite = 0;
    this.suggestionType="";
    this.createdAt = DateTime.now().millisecondsSinceEpoch;
    this.updatedAt = DateTime.now().millisecondsSinceEpoch;
    this.itemFields = itemFields;
  }

  updateItem(Item currentItem, String newTitle) {
    currentItem.title = newTitle;
    currentItem.updatedAt = DateTime.now().millisecondsSinceEpoch;
  }

  Item(
      {this.id,
      this.title,
      this.suggestionType,
      this.favourite,
      this.createdAt,
      this.updatedAt,
      this.itemFields});

  Item.fromJson(Map<String, dynamic> json) {
    id = json['itemId'];
    title = json['title'];
    suggestionType = json['suggestion_type'];
    favourite = json['favourite'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];

    //json to list
    // if (json['itemFields'] != null) {
    //   itemFields = new List<ItemField>();
    //   json['itemFields'].forEach((v) {
    //     itemFields.add(new ItemField.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemId'] = this.id;
    data['title'] = this.title;
    data['suggestion_type']=this.suggestionType;
    data['favourite'] = this.favourite;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;

    // list into json
    // if (this.itemFields != null) {
    //   data['itemFields'] = this.itemFields.map((v) => v.toJson()).toList();
    // }
    return data;
  }

  static const String tableName = 'T_Item';
  static const String colId = 'itemId';
  static const String colTitle = 'title';
  static const String colSuggestionType = 'suggestion_type';
  static const String colFav = 'favourite';
  static const String colCreatedAt = 'createdAt';
  static const String colUpdatedAt = 'updatedAt';

  static const String createTable = """ 
     CREATE TABLE IF NOT EXISTS $tableName (
   $colId INTEGER PRIMARY KEY AUTOINCREMENT,    
   $colTitle TEXT NOT NULL,
   $colSuggestionType TEXT,
   $colFav INTEGER,
   $colCreatedAt Integer,
   $colUpdatedAt Integer
   )""";

  static const String fetchQuery = 'SELECT * FROM $tableName';
}
