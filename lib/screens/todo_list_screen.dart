
import 'package:flutter/material.dart';
import 'package:todo_app/screens/add_task_screen.dart';

class ToDo extends StatefulWidget {
  @override
  _ToDoState createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
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
          Navigator.push(context, MaterialPageRoute(builder: (_)=> AddTask()));
        },
        backgroundColor: Colors.green,
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Task",style: TextStyle(
          color: Colors.black
        )),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index){
            return TaskLayout(index);
          }
      ) ,
    );
  }

  Widget TaskLayout(int index){
    return Padding(
      padding: const EdgeInsets.only(left: 5,right: 5,bottom: 5),
      child: Column(
        children: [
          ListTile(
              title: Text('Task title'),
              subtitle: Text('date - high'),
              trailing: Checkbox(
                onChanged: (value){
                  print(value);
                },
                activeColor: Colors.green,
                value: true,
              )
          ),
          Divider()
        ],
      ),
    );
  }
}

