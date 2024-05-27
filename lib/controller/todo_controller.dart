import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todo_app/models/HomeModel.dart';
import 'package:todo_app/models/TodoModel.dart';
import '../utils/common.dart';
import '../utils/database/TodoDatabase.dart';

class TodoController extends ChangeNotifier {

  ///--------------------

  TextEditingController titleTextEditingController = TextEditingController();
  TextEditingController categoryTextEditingController = TextEditingController();
  TextEditingController descriptionTextEditingController = TextEditingController();
  TextEditingController dueDateEditingController = TextEditingController();

  List<String> taskCategoryList = ['personal','shopping','work'];

  String selectedCategory = 'personal';

  String? selectedDueDate ;

  void disposeTodoController() {
    titleTextEditingController.clear();
    descriptionTextEditingController.clear();
    dueDateEditingController.clear();
  }

  void setSelectedCategory(String value){
    selectedCategory = value;
    notifyListeners();
  }

  void setSelectedDueDate(String value){
    selectedDueDate = value;
    dueDateEditingController.text = value.toString();
    notifyListeners();
  }

  int selectedIndex = 0;

  void setTabIndex(int value){
    selectedIndex = value;
    notifyListeners();
  }






  /// -------------------------DataBase-------------------

  final TodoDatabase todoDatabase = TodoDatabase();


  List<TodoModel> _todos = [];

  List<TodoModel> get todos => _todos;

  Future<void> getTodos() async {
    _todos = await todoDatabase.getTodos();
    log("--------getTodos _todos ${_todos.length}");
    notifyListeners();
  }

  Future<void> addTodo(TodoModel todo) async {
    try{
      await todoDatabase.insertTodo(todo);
      await getTodos();
    }catch(e){
      log("Error While adding todo ${e.toString()}");
    }
  }

  /// method for update todo
  Future<void> updateTodo(TodoModel todo) async {
    try{
      await todoDatabase.updateTodo(todo);
      await getTodos();
    }catch(e){
      log("Error While updating todo ${e.toString()}");
    }
  }

  /// method for isCompleted update
  Future<void> updateCheckTodo(TodoModel todo, bool isCompleted) async {
    try {
      todo.isCompleted = isCompleted ? 1 : 0;
      await todoDatabase.updateTodo(todo);
      await getTodos();
    } catch (e) {
      log("Error While updating todo ${e.toString()}");
    }
  }

  /// method for delete todo
  Future<void> deleteTodo(String id) async {
    try{
      await todoDatabase.deleteTodo(id);
      await getTodos();
    }catch(e){
      log("Error While deleting todo ${e.toString()}");
    }
  }


  List<TodoModel> filterTasksByCategory(List<TodoModel> allTasks, String category) {
    return allTasks.where((task) => task.category == category).toList();
  }

  /// method for getting home screen data
  Future<HomeModel> getHomePageData() async {
    _todos = await todoDatabase.getTodos();
    log("_todos.length ${_todos.length}");

    List<TodoModel> allTasks = _todos;
    List<TodoModel> todayDueDateTasks = _todos.where((todo) => isTaskDueToday(todo.dueDate)).toList();
    List<TodoModel> overDueTasks = _todos.where((todo) => isTaskOverdue(todo.dueDate)).toList();
    List<TodoModel> scheduledTasks = _todos.where((todo) =>
    todo.dueDate != null &&
        !isTaskDueToday(todo.dueDate) &&
        !isTaskOverdue(todo.dueDate)
    ).toList();

    int allTaskCount = allTasks.length;
    int todayTaskCount = todayDueDateTasks.length;
    int overdueTaskCount = overDueTasks.length;
    int scheduledTaskCount = scheduledTasks.length;

    log("Total Tasks: $allTaskCount, Today Tasks: $todayTaskCount, Overdue Tasks: $overdueTaskCount, Scheduled Tasks: $scheduledTaskCount");

    return HomeModel(
      allCount: allTaskCount,
      overDueCount: overdueTaskCount,
      scheduledCount: scheduledTaskCount,
      todayCount: todayTaskCount,
      allTasksList: allTasks,
      overDueTasksList: overDueTasks,
      scheduledTasksList: scheduledTasks,
      todayDueDateList: todayDueDateTasks,
    );
  }



}

