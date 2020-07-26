
class Keypass{

  Keypass(this._key,this._password,[this._date]);

  Keypass.withId(this._id,this._key,this._password,[this._date]);
  
  Keypass.getObject(Map<String, dynamic> map){
    Keypass(map['id'],map['key'],map['password']);
    if(map['date']!=null){
      _date=map['date'];
    }
  } 
  
  int _id;
  String _key;
  String _password;
  String _date;
 
   Map<String,dynamic> toMap(){

      Map<String, dynamic> map = Map<String,dynamic>();

      if(_id!=null){
        map['id']=_id;
      }
      map['key']=_key;
      map['password']=_password;
      map['date'] = _date;
  
      return map;
  }


  static const String dbName = 'keypass';
  static const String colId = 'id';
  static const String passTable = 'pass_table';
  static const String colKey = 'key';
  static const String colPassword = 'password';
  static const String colDate = 'date';

  static const String createQuery = """ 
     CREATE TABLE $passTable (
   $colId INTEGER PRIMARY KEY NOT NULL,    
   $colKey TEXT NOT NULL,
   $colPassword TEXT NOT NULL,
   $colDate TEXT
   )""";


   //Specific to each table
 // int get id => _id;
  // String get key => _key;
  // String get password => _password;
  // String get date => _date;

  // set key(String key){
  //   _key=key;
  // }
  // set password(String password){
  //   _password=password;
  // }

  // set date(String date){
  //   _date=date;
  // }
 
}