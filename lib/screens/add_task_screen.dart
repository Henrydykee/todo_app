
import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/helpers/db_helpers.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';

class AddTask extends StatefulWidget {
  final  Task task;
  final Function updateTaskList;

  AddTask({this.task,this.updateTaskList});

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _priority = "Low" ;
  DateTime _date = DateTime.now();
  final maxLines = 10;
  bool _isInitialized = false;
  

 TextEditingController _dateController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _noteController = TextEditingController();

 final DateFormat _dateFormat = DateFormat('MMM DD, yyy');
 final List<String> _priorites =['Low','Medium','High'];
  bool _visibilityObs = false;
  int cameraOcr = FlutterMobileVision.CAMERA_BACK;

  @override
  void initState() {
    FlutterMobileVision.start().then((value) {
      _isInitialized = true;
    });

    if(widget.task != null){
        _titleController.text = widget.task.title;
        _date = widget.task.date;
        _priority = widget.task.priority;
        _noteController.text = widget.task.note;
    }
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

  _submit(){
    if(_formKey.currentState.validate()){
      Task task = Task(title: _titleController.text, date: _date, priority: _priority,note: _noteController.text);
      if(widget.task == null){
        task.status = 0;
        DatabaseHelper.instance.insertTask(task);
      }else{
        task.id = widget.task.id;
        task.status = widget.task.status;
        DatabaseHelper.instance.updateTask(task);
      }
      widget.updateTaskList();
      Navigator.pop(context);
    }
  }

  _delete(){
    DatabaseHelper.instance.deleteTask(widget.task.id);
    widget.updateTaskList();
    Navigator.pop(context);
  }

 Future <Null> _startScan() async {
    List<OcrText> list = List();
    try{
      list = await FlutterMobileVision.read(
        waitTap: true,
        fps:  5,
        multiple:  true,
        camera: cameraOcr
      );
      for (OcrText text in list ){
        setState(() {
          _noteController.text = text.value.toString();
        });
      }
    }
    catch(e){
    print("this is the error: ${e.toString()}");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: AvatarGlow(
          endRadius: 60.0,
          child: Icon(
            Icons.check,
            color: Colors.white,
          ),
        ),
        onPressed: () {
          log("${_titleController.text}, $_priority, $_date");
            _submit();
        },
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Visibility(
          visible: widget.task != null,
          child: IconButton(
            onPressed: () {
              _delete();
            },
            icon: Icon(Icons.delete_forever_rounded,color: Colors.red,size: 30,),
          ),
        ),
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
        title: Text(widget.task == null ? "Add Note" : "Update Note",style: TextStyle(
          color: Colors.black
        ),),
      ),
      body: GestureDetector(
        onTap: ()=> FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
              child: Column(
                children: [
                  Visibility(
                    visible: widget.task?.status == 1 ? true : false ,
                    child: Container(
                      width:double.infinity,
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("You marked this note as completed",style: TextStyle(
                          color: Colors.white
                        ),),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 25,right: 25),
                    child: TextFormField(
                      controller: _titleController,
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
                  ),
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.only(left: 25,right: 25),
                    child: TextFormField(
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
                  ),
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.only(left: 25,right: 25),
                    child: DropdownButtonFormField(
                      value: _priority,
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
                      validator: (input) => input.toString().trim().isEmpty ? 'Please input a priority level' : null,
                      onChanged: (value) {
                        setState(() {
                          _priority = value;
                        });
                      },
                      onSaved: (input) => _priority = input,
                    ),
                  ),
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.only(left: 25,right: 25),
                    child: TextFormField(
                      validator: (input)=>input.trim().isEmpty? "Note cannot be blank" : null,
                      controller: _noteController,
                      maxLines: maxLines,
                      decoration: InputDecoration(
                          labelText: "Notes",
                          labelStyle: TextStyle(fontSize: 18),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)
                          )
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Container(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: _startScan,
                      child: Center(
                        child: Icon(Icons.camera_enhance_outlined,size: 35,),
                      ),
                    ),
                  )
                ],
              )
          ),
        ),
      ),
    );
  }
}
