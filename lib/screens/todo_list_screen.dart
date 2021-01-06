import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/helpers/db_helpers.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/screens/add_task_screen.dart';

class ToDo extends StatefulWidget {
  @override
  _ToDoState createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {

  Future<List<Task>> _taskList;
  final hour = DateTime.now().hour;
  final DateFormat _dateFormat = DateFormat('MMM DD, yyy');

  @override
  void initState() {
    super.initState();
    if (hour > 0 && hour < 12) {
      print('morning');
    } else if (hour > 12 &&  hour < 18){
      print("afternoon");
    }  else if (hour > 18 &&  hour < 24 ){
      print("evening");
    }
    _updateTaskList();
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AddTask(
                        updateTaskList: _updateTaskList,
                      )));
        },
        backgroundColor: Colors.green,
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Task", style: TextStyle(color: Colors.black)),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: FutureBuilder(
          future: _taskList,
          builder: (context, snapshot) {
            if(snapshot.data != null){
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    final task = snapshot.data[index];
                    return TaskLayout(task);
                  });
            }else{
              return Center(
                child: Text(
                  "Nothing",
                  style: TextStyle(color: Colors.black),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget TaskLayout(Task task) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
      child: Column(
        children: [
          ListTile(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AddTask(
                          updateTaskList: _updateTaskList, task: task))),
              title: Text(
                '${task.title}',
                style: TextStyle(
                    fontSize: 18,
                    decoration: task.status == 0
                        ? TextDecoration.none
                        : TextDecoration.lineThrough),
              ),
              subtitle: Text(
                '${_dateFormat.format(task.date)} - ${task.priority}',
                style: TextStyle(
                    fontSize: 15,
                    decoration: task.status == 0
                        ? TextDecoration.none
                        : TextDecoration.lineThrough),
              ),
              trailing: Checkbox(
                onChanged: (value) {
                  task.status = value ? 1 : 0;
                  DatabaseHelper.instance.updateTask(task);
                  _updateTaskList();
                },
                activeColor: Colors.green,
                value: task.status == 1 ? true : false,
              )),
          Divider()
        ],
      ),
    );
  }
}
