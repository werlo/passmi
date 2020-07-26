import 'package:flutter/material.dart';
import 'package:passmi/screens/home_page.dart';
import 'package:passmi/screens/login_page.dart';
import 'dart:async';
import '../Service/coreservice.dart';
import '../utils/basic_constants.dart';

class SignupPage extends StatefulWidget {
//  static final _loginService = LoginService();
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  String password;
  String confirmPassword;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Constants.mainAppColor,
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
            "SIGN UP",
            style: TextStyle(
                color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Card(
                  margin: EdgeInsets.only(
                    right: 25,
                    left: 25,
                  ),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    expands: false,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter Password',
                    ),
                    onSaved: (text) => password = text,
                  ),
                ),
                Card(
                  margin: EdgeInsets.only(
                    right: 25,
                    left: 25,
                  ),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    expands: false,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter Password Again',
                    ),
                    onSaved: (text) => confirmPassword = text,
                  ),
                ),
                RaisedButton(
                  child: Text("SIGNUP"),
                  color: Colors.white,
                  onPressed: () async {
                    _formKey.currentState.save();
                    if (password == confirmPassword) {
                      CoreService().openDB(password);
                      navigateToLoginPage();
                    } else {
                      // TODO: password mismatch case
                      debugPrint("****************************");
                      debugPrint(password);
                      debugPrint(confirmPassword);
                      debugPrint("****************************");
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void navigateToLoginPage() async {
    CoreService().dbInstance = null;
    CoreService.coreService = null;
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LoginPage();
    }));
  }
}
