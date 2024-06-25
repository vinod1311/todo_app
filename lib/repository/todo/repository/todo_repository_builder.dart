
import 'package:todo_app/repository/todo/contract/todo_repository.dart';
import 'package:todo_app/repository/todo/repository/todo_repository_impl.dart';

abstract class TodoRepositoryBuilder{
  static TodoRepository repository(){
    return TodoRepositoryImpl();
  }
}