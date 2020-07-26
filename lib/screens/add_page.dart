import 'package:flutter/material.dart';
import 'package:passmi/Service/coreservice.dart';
import '../models/itemField.dart';
import '../models/item.dart';
import '../Service/coreservice.dart';

class AddPage extends StatefulWidget {
  @override
  AddPageState createState() => AddPageState();
}

class AddPageState extends State<AddPage> {
  static var properties = ['High', 'Low'];
  bool switchValue = false;
  Map<String, String> fieldNameToFieldMap = Map();
  List<String> fieldList = [
    'password',
    'email',
    'pin',
    'note',
    'number',
    'username'
  ];
  static List<Widget> selectedFieldList = new List();
  Column fieldColumnList;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TextEditingController addNewFieldTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedFieldList.clear();
  }

  @override
  Widget build(BuildContext context) {
    fieldColumnList = new Column(
      children: selectedFieldList,
    );
    TextStyle textStyle = Theme.of(context).textTheme.title;

    return new Scaffold(
      appBar: AppBar(
        title: Text('Add Item'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: titleController,
                style: textStyle,
                onChanged: (value) {
                  debugPrint('value in the text field changed');
                },
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            Form(key: _formKey, child: fieldColumnList),
            Wrap(
              children: listOfFields(),
            ),
            RaisedButton(
              child: Text('add your own field'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onPressed: () {
                return showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        backgroundColor: Colors.blueGrey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Container(
                          height: 290,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Field Name',
                                style: TextStyle(
                                  fontSize: 30,
                                ),
                              ),
                              Card(
                                margin: EdgeInsets.only(
                                  left: 30,
                                  right: 30,
                                  top: 15,
                                ),
                                child: TextField(
                                  controller: addNewFieldTextController,
                                  enableSuggestions: true,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: 'eg. pin , cvv',
                                  ),
                                ),
                              ),
                              SwitchListTile(
                                title: const Text('Is this field sensitive? '),
                                value: switchValue,
                                onChanged: (bool value) {
                                  setState(() {
                                    switchValue = value;
                                  });
                                },
                                secondary: const Icon(Icons.lightbulb_outline),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    color: Colors.black87,
                                    child: FlatButton(
                                      onPressed: () {
                                        popOutAddFieldPopUp();
                                      },
                                      child: Text(
                                        'CANCEL',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    color: Colors.black87,
                                    child: FlatButton(
                                      onPressed: () {
                                        setState(() {
                                          fieldList.add(
                                              addNewFieldTextController.text);
                                          addNewFieldTextController.text = '';
                                          popOutAddFieldPopUp();
                                        });
                                      },
                                      child: Text(
                                        'SAVE',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                color: Colors.deepOrangeAccent,
                textColor: Colors.white,
                child: Text('Save'),
                onPressed: () {
                  _formKey.currentState.save();
                  debugPrint(titleController.text);
                  debugPrint("********************");
                  fieldNameToFieldMap.forEach((key, value) {
                    debugPrint(key + " : " + value);
                  });
                  debugPrint("********************");
                  bool b =
                      saveThisItem(titleController.text, fieldNameToFieldMap);
                  debugPrint(b.toString());
                  popOutAddFieldPopUp();
                },
              ),
            ),
            Expanded(
              child: RaisedButton(
                color: Colors.deepOrangeAccent,
                textColor: Colors.white,
                child: Text('Delete'),
                onPressed: () {
                  setState(() {
                    debugPrint(' Delete Clicked ');
                  });
                },
              ),
            ),
          ],
        ),
        color: Colors.deepOrangeAccent,
      ),
    );
  }

  Future<bool> popOutAddPage() {
    debugPrint('yo i am called');
    selectedFieldList.clear();
    fieldList = ['password', 'email', 'pin', 'note', 'number', 'username'];
    return Future.value(true);
  }

  List<Widget> listOfFields() {
    List<Widget> listOfWidgets = new List();

    fieldList.forEach((field) {
      listOfWidgets.add(new Container(
        margin: EdgeInsets.only(
          left: 7,
        ),
        child: RaisedButton(
          onPressed: () {
            setState(() {
              selectedFieldList.add(
                Card(
                  key: ValueKey(field),
                  margin: EdgeInsets.symmetric(vertical: 3),
                  child: ListTile(
                    leading: Text(field),
                    title: TextFormField(
                      textAlign: TextAlign.center,
                      expands: false,
                      obscureText: false,
                      style: TextStyle(
                        color: Colors.teal[900],
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: 'enter ' + field,
                      ),
                      onSaved: (value) {
                        fieldNameToFieldMap[field] = value;
                      },
                    ),
                    trailing: FlatButton(
                      child: Icon(
                        Icons.close,
                      ),
                      onPressed: () {
                        setState(() {
                          debugPrint('inside state');
                          fieldList.add(field);
                          selectedFieldList.removeWhere((test) {
                            debugPrint('inside');
                            debugPrint(test.key.toString());
                            debugPrint(ValueKey(field).toString());
                            if (test.key == ValueKey(field)) {
                              return true;
                            } else
                              return false;
                          });
                        });
                      },
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
              fieldList.remove(field);
            });
          },
          child: Text(field),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ));
    });

    return listOfWidgets;
  }

  bool saveThisItem(String itemTitle, Map<String, String> itemFields) {
    List<ItemField> iFields = List();

    itemFields.forEach((key, value) {
      ItemField field = new ItemField();
      field.createItemFieldFromUI(key, value, isSensitive: false);
      iFields.add(field);
    });

    Item mainItem = Item.createItemFromUI(itemTitle, iFields);
    bool isItemSaved;
    CoreService()
        .insertItem(mainItem)
        .then((onValue) => isItemSaved = true)
        .catchError((onError) => isItemSaved = false);
    return isItemSaved;
  }

  void popOutAddFieldPopUp() {
    Navigator.pop(context, true);
  }

//  List<ItemField> createItemFieldList() {
//    List<ItemField> itemFields = new List<ItemField>();
//
//    // create item Field list from listOfFields()
//    listOfFields().forEach((v) {
//      itemFields.add(new ItemField().createItemFieldFromUI('title', 'value'));
//    });
//    return itemFields;
//  }

//  bool saveItemInDataBase() {
//    Item item = Item.createItemFromUI('title', createItemFieldList());
//    Future<void> result = CoreService.insertItem(item);
//    return result;
//  }
//
//  bool updateItemInDatabase() {
//    Item updatedItem = Item(); //update
//    List<ItemField> updatedFields = List<ItemField>(); //update
//    List<ItemField> newFields = List<ItemField>(); //add
//    List<int> deletedFields = List<int>(); //delete
//    return true;
//  }
}
