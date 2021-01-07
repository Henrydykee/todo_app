import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_app/screens/name.dart';
import 'package:todo_app/screens/todo_list_screen.dart';
import 'package:todo_app/utils.dart';

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    PrefUtils.getIsUserLoggedIn().then((value){
      if(value != null ){
        Timer(
            Duration(seconds: 3),
                () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => ToDo())));
      } else{
        Timer(
            Duration(seconds: 3),
                () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => NameScreen())));

      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text('NOTEBOOK',style: TextStyle(
          fontSize: 50,
          fontWeight: FontWeight.bold
        ),),
      ),
    );
  }
}
