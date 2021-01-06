import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

import 'package:todo_app/models/task_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database _db;

  DatabaseHelper._instance();

  String taskTable = 'task_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDate = 'date';
  String colPriority = 'priority';
  String colStatus = 'status';

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  _initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "todo_list.db");
    final todoListDb =
        await openDatabase(path, version: 1, onCreate: _onCreate);
    return todoListDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE $taskTable ($colId  INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDate TEXT, $colPriority TEXT, $colStatus INTEGER )");
    print("Created tables");
  }

  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    Database database = await this.db;
    // List<Map> list = await dbClient.rawQuery('SELECT * FROM $taskTable');
    // List<Task> task = new List();
    final List<Map<String, dynamic>> result = await database.query(taskTable);
    return result;
  }

  Future<List<Task>> getTaskList() async {
    final List<Map<String, dynamic>> taskMapList = await getTaskMapList();
    final List<Task> taskList = [];
    taskMapList.forEach((taskMap) {
      taskList.add(Task.fromMap(taskMap));
    });
    taskList.sort((taskA, taskB) => taskA.date.compareTo(taskB.date));
    return taskList;
  }

  Future<int> insertTask(Task task) async {
    Database database = await this.db;
    final int result = await database.insert(taskTable, task.toMap());
    return result;
  }

  Future<int> deleteTask(int id) async {
    Database database = await this.db;
    final int result =
        await database.delete(taskTable, where: '$colId = ?', whereArgs: [id]);
    return result;
  }

  Future<int> updateTask(Task task) async {
    Database database = await this.db;
    final int result = await database.update(taskTable, task.toMap(),
        where: '$colId = ?', whereArgs: [task.id]);
    return result;
  }
}
