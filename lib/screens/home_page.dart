import 'dart:io';
import 'package:flutter/material.dart';
import 'package:passmi/screens/edit_page.dart';
import 'add_page.dart';
import '../models/item.dart';
import '../models/itemField.dart';
import '../Service/coreservice.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Item> itemList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (itemList == null) {
      itemList = List<Item>();
      updateListView();
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Passmi'),
        ),
        body: getMainList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigateToAddPage();
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  ListView getMainList() {
    TextStyle titleStyle = Theme.of(context).textTheme.title;

    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: FlatButton(
                  child: Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    CoreService()
                        .getItemFields(this.itemList[position])
                        .then((value) {
                      this.itemList[position].itemFields = value;
                      navigateToEditPage(this.itemList[position]);
                    });
                  }),
              title: Text(
                this.itemList[position].title,
                style: titleStyle,
              ),

              // TODO: subtitle text?
              //subtitle: Text('this is the subtitle'),

              // TODO: any trailing Icon?
              trailing: FlatButton(
                  child: Icon(
                    Icons.delete,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    deleteThisItem(this.itemList[position]);
                  }),
              onTap: () {
                // TODO: show Details of this.item
                debugPrint('------- list tile tapped -------');
                getItemDetails(
                    this.itemList[position]); // this is for testing purpose.

                //TODO: write the code for expandable card here
                /*CoreService()
                    .getItemFields(this.itemList[position])
                    .then((value) {
                  this.itemList[position].itemFields = value;
                  debugPrint('list of fields is -----------------');
                  this.itemList[position].itemFields.forEach((element) {
                    String title = element.fieldTitle;
                    String value = element.fieldValue;
                    debugPrint('$title ======= $value');
                  });
                  debugPrint('end of itemFields -----------------');
                });*/
              },
            ),
          );
        });
  }

  void getItemDetails(Item currentItem) async {
    List<ItemField> itemFields = List<ItemField>();
    itemFields = await CoreService().getItemFields(currentItem);
    debugPrint('list of fields is -----------------');
    itemFields.forEach((element) {
      String title = element.fieldTitle;
      String value = element.fieldValue;
      debugPrint('$title ======= $value');
    });
    debugPrint('end of itemFields -----------------');
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToEditPage(Item currentItem) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditPage(); // TODO: use this as edit page too.
    }));

    if (result == true) {
      updateListView();
    }
  }

  void navigateToAddPage() async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddPage(); // TODO: use this as edit page too.
    }));

    if (result == true) {
      updateListView();
    }
  }

  void deleteThisItem(Item current) {
    CoreService().deleteItem(current).then((value) => null);
    updateListView();
  }

  void updateListView() {
    // TODO: get all items from CoreService()
    CoreService().getAllItem().then((value) {
      setState(() {
        CoreService().logger.wtf('item list is....... $value');
        this.itemList = value;
        this.count = value.length;
      });
    });
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit App'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () {
                  debugPrint("Exiting APP!");
                  exit(0);
                },
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
