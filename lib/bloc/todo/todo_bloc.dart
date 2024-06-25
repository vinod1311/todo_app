import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/todo/todo_event.dart';
import 'package:todo_app/bloc/todo/todo_state.dart';
import 'package:todo_app/repository/todo/contract/todo_repository.dart';


class TodoBloc extends Bloc<TodoEvent,TodoState>{
  final TodoRepository _todoRepository;

  TodoBloc(this._todoRepository): super(TodoLoading()){
    on<TodosLoadedEvent>(_onLoadTodos);
    on<HomePageDataLoadedEvent>(_onLoadHomePageData);
    on<AddTodoEvent>(_onAddTodo);
    on<UpdateTodoEvent>(_onUpdateTodo);
    on<UpdateCheckTodoEvent>(_onUpdateCheckTodo);
    on<DeleteTodoEvent>(_onDeleteTodo);
  }

  ///-------- for getting todos
  void _onLoadTodos(TodosLoadedEvent event, Emitter<TodoState> emit) async{
    try {
      final todos = await _todoRepository.getTodos();
      emit(TodoLoaded(todos));
      add(HomePageDataLoadedEvent());
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  ///-------- for getting todos
  void _onLoadHomePageData(HomePageDataLoadedEvent event, Emitter<TodoState> emit) async{
    try {
      final homePageData = await _todoRepository.getHomePageData();
      emit(HomePageDataLoaded(homePageData));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  void _onAddTodo(AddTodoEvent event, Emitter<TodoState> emit) async{
    try{
      await _todoRepository.addTodo(event.todo);
      add(TodosLoadedEvent());
      add(HomePageDataLoadedEvent());
    }catch(e){
      emit(TodoError(e.toString()));
    }
  }

  void _onUpdateTodo(UpdateTodoEvent event, Emitter<TodoState> emit) async{
    try{
      await _todoRepository.updateTodo(event.todo);
      add(TodosLoadedEvent());
      add(HomePageDataLoadedEvent());
    }catch(e){
      emit(TodoError(e.toString()));
    }
  }

  void _onUpdateCheckTodo(UpdateCheckTodoEvent event, Emitter<TodoState> emit) async{

    try{
      await _todoRepository.updateCheckTodo(event.todo, event.isCompleted);
      // ----- Reload the todos after update
      add(TodosLoadedEvent());
      add(HomePageDataLoadedEvent());
    }catch(e){
      emit(TodoError(e.toString()));
    }
  }

  void _onDeleteTodo(DeleteTodoEvent event, Emitter<TodoState> emit) async{
    try{
      await _todoRepository.deleteTodo(event.id);
      add(TodosLoadedEvent());
      add(HomePageDataLoadedEvent());
    }catch(e){
      emit(TodoError(e.toString()));
    }
  }
}