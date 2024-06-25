import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo_app/repository/todo/model/todo_model.dart';

@immutable
abstract class TodoEvent extends Equatable{
  const TodoEvent();

  @override
  List<Object> get props => [];
}

/// ------ event for getting todos
class TodosLoadedEvent extends TodoEvent{}

/// ----- event for adding todos
class AddTodoEvent extends TodoEvent{
  final TodoModel todo;

  const AddTodoEvent(this.todo);

  @override
  List<Object> get props => [todo];
}

/// ---- event for updating todos
class UpdateTodoEvent extends TodoEvent {
  final TodoModel todo;

  const UpdateTodoEvent(this.todo);

  @override
  List<Object> get props => [todo];
}

/// ----- event for deleting todos
class DeleteTodoEvent extends TodoEvent {
  final String id;

  const DeleteTodoEvent(this.id);

  @override
  List<Object> get props => [id];
}

/// ------ event for updating check for isComplete
class UpdateCheckTodoEvent extends TodoEvent {
  final TodoModel todo;
  final bool isCompleted;

  const UpdateCheckTodoEvent(this.todo,this.isCompleted);

  @override
  List<Object> get props => [todo,isCompleted];
}

class HomePageDataLoadedEvent extends TodoEvent {}


