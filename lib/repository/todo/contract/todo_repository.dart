
import '../model/home_model.dart';
import '../model/todo_model.dart';

abstract class TodoRepository{

  Future<void> addTodo(TodoModel todo);

  Future<List<TodoModel>> getTodos();

  Future<void> updateTodo(TodoModel todo);

  Future<void> updateCheckTodo(TodoModel todo, bool isCompleted);

  Future<void> deleteTodo(String id);

  Future<HomeModel> getHomePageData();
}