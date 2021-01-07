
import 'package:flutter/material.dart';
import 'package:todo_app/screens/todo_list_screen.dart';
import 'package:todo_app/utils.dart';
import 'package:avatar_glow/avatar_glow.dart';

class NameScreen extends StatefulWidget {
  @override
  _NameScreenState createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {

  TextEditingController  _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: AvatarGlow(
          endRadius: 60.0,
          child: Icon(
            Icons.arrow_right_alt,
            color: Colors.white,
            size: 30,
          ),
        ),
        onPressed: () {
          if(_formKey.currentState.validate()){
            PrefUtils.setFirstName(_nameController.text.toString());
            PrefUtils.setUserIsLoggedIn(true);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ToDo()));
          }
        },
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("WELCOME", style: TextStyle(color: Colors.black)),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 25,right: 25),
          child: Column(
            children: [
              SizedBox(height: 20,),
              Form(
                key: _formKey,
                child: TextFormField(
                  validator: (input)=>input.trim().isEmpty? "please enter name" : null,
                 controller: _nameController,
                  style: TextStyle(fontSize: 18.0),
                  decoration: InputDecoration(
                      labelStyle: TextStyle(fontSize: 18),
                      hintText: "Please input FirstName",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)
                      )
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
