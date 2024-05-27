import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../models/TodoModel.dart';

class TodoDatabase {
  static final TodoDatabase _instance = TodoDatabase._internal();
  factory TodoDatabase() => _instance;

  TodoDatabase._internal();

  late Database _db;

  Future<void> initializeDatabase() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), 'todo_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE todos(id TEXT PRIMARY KEY, title TEXT, category TEXT, description TEXT, dueDate TEXT,isCompleted INTEGER)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertTodo(TodoModel todo) async {
    await _db.insert('todos', todo.toJson());
  }

  Future<List<TodoModel>> getTodos() async {
    final List<Map<String, dynamic>> maps = await _db.query('todos');
    return List.generate(maps.length, (i) {
      return TodoModel.fromJson(maps[i]);
    });
  }

  Future<void> updateTodo(TodoModel todo) async {
    await _db.update(
      'todos',
      todo.toJson(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<void> deleteTodo(String id) async {
    await _db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
