
import 'dart:developer';

import 'package:todo_app/repository/todo/contract/todo_repository.dart';
import 'package:todo_app/repository/todo/model/home_model.dart';
import 'package:todo_app/repository/todo/model/todo_model.dart';

import '../../../utils/common.dart';
import '../../../utils/database/TodoDatabase.dart';

class TodoRepositoryImpl implements TodoRepository {

  final TodoDatabase todoDatabase = TodoDatabase();

  @override
  Future<void> addTodo(TodoModel todo) async{
    try{
      await todoDatabase.insertTodo(todo);
    }catch(e){
      log("Error While adding todo ${e.toString()}");
    }
  }

  @override
  Future<void> deleteTodo(String id) async{
    try{
      await todoDatabase.deleteTodo(id);
    }catch(e){
      log("Error While deleting todo ${e.toString()}");
    }
  }

  @override
  Future<HomeModel> getHomePageData() async{
    List<TodoModel> todos = await todoDatabase.getTodos();
    log("_todos.length ${todos.length}");

    List<TodoModel> allTasks = todos;
    List<TodoModel> todayDueDateTasks = todos.where((todo) => isTaskDueToday(todo.dueDate)).toList();
    List<TodoModel> overDueTasks = todos.where((todo) => isTaskOverdue(todo.dueDate)).toList();
    List<TodoModel> scheduledTasks = todos.where((todo) =>
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

  @override
  Future<void> updateCheckTodo(TodoModel todo, bool isCompleted) async{
    try {
      todo.isCompleted = isCompleted ? 1 : 0;
      await todoDatabase.updateTodo(todo);

    } catch (e) {
      log("Error While updating todo ${e.toString()}");
    }
  }

  @override
  Future<void> updateTodo(TodoModel todo) async{
    try{
      await todoDatabase.updateTodo(todo);
    }catch(e){
      log("Error While updating todo ${e.toString()}");
    }
  }

  @override
  Future<List<TodoModel>> getTodos() async{
    try{
      return await todoDatabase.getTodos();
    }catch(e){
      log("Error While getting todo ${e.toString()}");
      rethrow;
    }
  }


}