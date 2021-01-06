import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/screens/todo_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        appBarTheme: AppBarTheme(brightness: Brightness.light),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ToDo(),
    );
  }
}



