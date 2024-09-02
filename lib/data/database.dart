// ignore_for_file: unused_field

import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  List toDoList = [];

  //reference our box
  final _myBox = Hive.box('mybox');

  //run thius method if this is the first time ever opening this app
  void createInitialData() {
    toDoList = [
      ["Make tutorial", false],
      ["Do exercise", false],
    ];
  }

  //load the data from database
  void loadData() {

    //works like a key value pair: we ask for key: "TODOLIST" and it returns value toDoList
    toDoList = _myBox.get("TODOLIST");

  }


  //update the database
  void updateDataBase() {
    _myBox.put("TODOLIST", toDoList);

  }



}