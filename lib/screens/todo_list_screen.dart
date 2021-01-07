import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/helpers/db_helpers.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/screens/add_task_screen.dart';
import 'package:todo_app/screens/name.dart';
import 'package:todo_app/utils.dart';
import 'package:avatar_glow/avatar_glow.dart';

class ToDo extends StatefulWidget {
  @override
  _ToDoState createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  Future<List<Task>> _taskList;
  final hour = DateTime.now().hour;
  final DateFormat _dateFormat = DateFormat('MMM DD, yyy');
  String time;
  String firstName = "";
  var colors = [Colors.pink, Colors.blue,Colors.red];

  @override
  void initState() {
    PrefUtils.getFirstName().then((value) => {
          setState(() {
            firstName = value;
          })
        });
    super.initState();
    if (hour > 0 && hour < 12) {
      setState(() {
        time = "Good Morning🌞,\nwhat are you doing today?";
      });
      print('morning');
    } else if (hour >= 12 && hour <= 17) {
      print("afternoon");
      setState(() {
        time = "Good Afternoon🌤,\nHave you washed your hands today ? ";
      });
    } else if (hour >= 17 && hour <= 19) {
      print("evening/night");
      setState(() {
        time = "Good Evening ☁️, How was your day?";
      });
    } else if (hour >= 19 && hour <= 24) {
      print("evening/night");
      setState(() {
        time = "Good Night 🌙, Sleep tight";
      });
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
        child: AvatarGlow(
          endRadius: 60.0,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AddTask(
                        updateTaskList: _updateTaskList,
                      )));
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (_) => NameScreen(
          //         )));
        },
        backgroundColor: Colors.green,
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Notes", style: TextStyle(color: Colors.black)),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25,right: 25,top: 8,bottom: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$firstName",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    color: hour > 0 && hour < 12 ? Colors.green : hour >= 12 && hour <= 18 ? Colors.red : hour >= 18 && hour <= 24 ?
                        Colors.black :  Colors.black
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "$time",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _taskList,
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  return  ListView.builder(
                      itemCount:  snapshot.data.length,
                      itemBuilder: (context, index) {
                        final task = snapshot.data[index];

                        return TaskLayout(task, index);
                      });
                } else {
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
        ],
      ),
    );
  }

  Widget TaskLayout(Task task,index) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color:  index % 2 == 0 ? colors[1] : colors[0]
        ),
        child:   ListTile(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AddTask(
                        updateTaskList: _updateTaskList, task: task))),
            title: Text(
              '${task.title}',
              style: TextStyle(
                color: Colors.white,
                  fontSize: 18),
            ),
            subtitle: Text(
              '${_dateFormat.format(task.date)} - ${task.priority}',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,),
            ),
            trailing: Theme(
              data: ThemeData(
                unselectedWidgetColor: Colors.white
              ),
              child: Checkbox(
                onChanged: (value) {
                  task.status = value ? 1 : 0;
                  if(task.status == 1){
                    Fluttertoast.showToast(
                        msg: "Marked as completed",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        //timeInSecForIosWeb: 1,
                        backgroundColor: Colors.transparent,
                        textColor: Colors.black,
                        fontSize: 12.0
                    );
                  }else if (task.status  == 0){
                    Fluttertoast.showToast(
                        msg: "Not completed",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        //timeInSecForIosWeb: 1,
                        backgroundColor: Colors.transparent,
                        textColor: Colors.black,
                        fontSize: 12.0
                    );
                  }
                  DatabaseHelper.instance.updateTask(task);
                  _updateTaskList();
                },
                activeColor: Colors.green,
                value: task.status == 1 ? true : false,
              ),
            )) ,
      ),
    );

    // return Padding(
    //   padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
    //   child: Column(
    //     children: [
    //       ListTile(
    //           onTap: () => Navigator.push(
    //               context,
    //               MaterialPageRoute(
    //                   builder: (_) => AddTask(
    //                       updateTaskList: _updateTaskList, task: task))),
    //           title: Text(
    //             '${task.title}',
    //             style: TextStyle(
    //                 fontSize: 18,
    //                 decoration: task.status == 0
    //                     ? TextDecoration.none
    //                     : TextDecoration.lineThrough),
    //           ),
    //           subtitle: Text(
    //             '${_dateFormat.format(task.date)} - ${task.priority}',
    //             style: TextStyle(
    //                 fontSize: 15,
    //                 decoration: task.status == 0
    //                     ? TextDecoration.none
    //                     : TextDecoration.lineThrough),
    //           ),
    //           trailing: Checkbox(
    //             onChanged: (value) {
    //               task.status = value ? 1 : 0;
    //               DatabaseHelper.instance.updateTask(task);
    //               _updateTaskList();
    //             },
    //             activeColor: Colors.green,
    //             value: task.status == 1 ? true : false,
    //           )),
    //       Divider()
    //     ],
    //   ),
    // );
  }
}
