import 'package:flutter/material.dart';
import '../Service/coreservice.dart';
import 'package:passmi/screens/login_page.dart';
import 'package:passmi/screens/signup_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
//  void initState() {
//    super.initState();
//  }

  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      // TODO: Remove Future Builder
//      future: Future.delayed(const Duration(milliseconds: 5000), () {
//        return CoreService().checkIfFirstTimeUser();
//      }),
      future: CoreService().checkIfFirstTimeUser(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          // while data is loading:
          debugPrint("did not receive data");
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          // data loaded:
          debugPrint("received data");
          return myMethod(snapshot.data);
        }
      },
    );
  }

  Widget myMethod(bool value) {
    CoreService().logger.wtf('first time user ----  $value');
    if (value == true) {
      return SignupPage();
    } else
      return LoginPage();
  }
}
