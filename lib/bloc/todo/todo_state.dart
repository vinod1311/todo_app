
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo_app/repository/todo/model/todo_model.dart';

import '../../repository/todo/model/home_model.dart';

@immutable
abstract class TodoState extends Equatable{
  const TodoState();

  @override
  List<Object?> get props => [];
}

/// ------ state for loading todos
class TodoLoading extends TodoState {}

/// ------- state for loading todos
class TodoLoaded extends TodoState {
  final List<TodoModel> todoList;

  const TodoLoaded(this.todoList);

  @override
  List<Object?> get props => [todoList];

}

/// ----- state for todos error
class TodoError extends TodoState{
  final String error;

  const TodoError(this.error);

  @override
  List<Object?> get props => [error];
}

/// ----- state for home page data
class HomePageDataLoaded extends TodoState {
  final HomeModel homeData;

  const HomePageDataLoaded(this.homeData);

  @override
  List<Object> get props => [homeData];
}





