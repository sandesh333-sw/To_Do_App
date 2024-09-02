// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, unused_field, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/data/database.dart';
import 'package:to_do_app/util/dialog_box.dart';
import 'package:to_do_app/util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //refrence the hive box
  final _myBox = Hive.box('mybox');

  //refrence the database
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {

    //if this is first time opening then create dea=fault data
    if (_myBox.get("TODOLIST") ==null ) {
      db.createInitialData();
    }
    else {
      db.loadData();
    }
  
    super.initState();
  }

  //text controller
  final _controller = TextEditingController();


  //checkbox was tapped
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] =! db.toDoList[index][1];
      
    });
    db.updateDataBase();
  }

  //save new tasks
  void saveNewTask() { 
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    //to remove the alert screen after saving the task
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  //create a new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          onSave: saveNewTask,
          onCancel: () =>Navigator.of(context).pop(),
          controller: _controller,
        );

    });
  }

  //delete task
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('TO DO'),
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {
          createNewTask();

        },
        child: Icon(Icons.add),
        backgroundColor: Colors.white,
        ),
        body: ListView.builder(
          itemCount: db.toDoList.length,
          itemBuilder: (context, index) {
            return TodoTile(
              taskName: db.toDoList[index][0],
              taskCompleted: db.toDoList[index][1],
              onChanged: (value) => checkBoxChanged(value, index),
              deleteFunction: (context) => deleteTask(index),
            );
          },

          
        ),
    );
  }
}