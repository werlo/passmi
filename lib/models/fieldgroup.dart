

class FieldGroup{

  int id;
  String title;
  String suggestionType;

  FieldGroup(this.id,this.title,{this.suggestionType});


  FieldGroup.fromJson(Map<String, dynamic> json) {
    id = json['fieldId'];
    title = json['fieldTitle'];
    suggestionType = json['suggestion_type'];

  }


   Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fieldId'] = this.id;
    data['fieldTitle'] = this.title;
    data['suggestion_type']=this.suggestionType;

    return data;

   }

  static const String tableName = 'T_FieldGroup';
  static const String colId = 'fieldId';
  static const String colTitle = 'fieldTitle';
  static const String colSuggestionType = 'suggestion_type';

  static const String createTable = """ 
     CREATE TABLE IF NOT EXISTS $tableName (
   $colId INTEGER PRIMARY KEY AUTOINCREMENT,    
   $colTitle TEXT NOT NULL,
   $colSuggestionType TEXT,
   )""";


}