
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String priority = "";
  DateTime _date = DateTime.now();

 TextEditingController _dateController = TextEditingController();

 final DateFormat _dateFormat = DateFormat('MMM DD, yyy');
 final List<String> _priorites =['Low','Medium','High'];

  @override
  void initState() {
    _dateController.text = _dateFormat.format(_date);
  }

  _handleDatePicker()async{
    final DateTime date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2025));

    if(date != null && date != _date){
      setState(() {
        _date = date;
      });
    }
    _dateController.text = _dateFormat.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
        onPressed: () {
          log("$_title, $priority, $_date");
        },
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Icons.close,color: Colors.black,size: 30,),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("Add Task",style: TextStyle(
          color: Colors.black
        ),),
      ),
      body: GestureDetector(
        onTap: ()=> FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(

          child: Form(
            key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 25,right: 25),
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    TextFormField(
                      style: TextStyle(fontSize: 18.0),
                      decoration: InputDecoration(
                        labelText: "Title",
                        labelStyle: TextStyle(fontSize: 18),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)
                        )
                      ),
                      validator: (input)=>input.trim().isEmpty? "please enter title" : null,
                      onSaved: (input)=> _title = input,
                      onChanged: (input){
                        setState(() {
                          _title = input;
                        });
                      },
                    ),
                    SizedBox(height: 15,),
                    TextFormField(
                      readOnly: true,
                      controller: _dateController,
                      style: TextStyle(fontSize: 18.0),
                      onTap: _handleDatePicker,
                      decoration: InputDecoration(
                          labelText: "Date",
                          labelStyle: TextStyle(fontSize: 18),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)
                          )
                      ),
                    ),
                    SizedBox(height: 15,),
                    DropdownButtonFormField(
                      items: _priorites.map((String priority){
                        return DropdownMenuItem(

                          value: priority,
                          child: Text(
                            priority,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0
                            ),
                          ),
                        );
                      }).toList(),
                      style: TextStyle(fontSize: 18.0),
                      decoration: InputDecoration(
                          labelText: "Priority",
                          labelStyle: TextStyle(fontSize: 18),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)
                          )
                      ),
                      validator: (input) => input.trim().isEmpty ? 'Please input a priority level' : null,
                      onChanged: (value) {
                        setState(() {
                          priority = value;
                        });
                      },
                      onSaved: (input) => priority = input,
                    )
                  ],
                ),
              )
          ),
        ),
      ),
    );
  }
}
