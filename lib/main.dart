import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:passmi/screens/login_page.dart';
import 'package:passmi/screens/signup_page.dart';
import 'package:passmi/screens/main_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}
