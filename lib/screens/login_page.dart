import 'package:flutter/material.dart';
import 'package:passmi/screens/home_page.dart';
import 'dart:async';
import '../Service/coreservice.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        image: DecorationImage(
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.1), BlendMode.dstATop),
          image: AssetImage('assets/images/john.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "LOGIN",
            style: TextStyle(
                color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
          ),
          Card(
            margin: EdgeInsets.only(
              right: 25,
              left: 25,
            ),
            child: TextField(
              controller: passwordController,
              textAlign: TextAlign.center,
              expands: false,
              obscureText: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter Password',
              ),
            ),
          ),
          RaisedButton(
            child: Text("LOGIN"),
            color: Colors.white,
            onPressed: () async {
              debugPrint("You Entered: "+passwordController.text);
              var mainDatabase = CoreService().openDB(passwordController.text);
              mainDatabase.then((onValue) {
                debugPrint(onValue.toString());
                navigateToHomePage();
              }).catchError((onError) {
                debugPrint('wrong password bro');
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  void navigateToHomePage() async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HomePage();
    }));
  }
}
