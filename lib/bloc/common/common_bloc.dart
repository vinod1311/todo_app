import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/common/common_event.dart';
import 'package:todo_app/bloc/common/common_state.dart';


class CommonBloc extends Bloc<CommonEvent, CommonState> {
  CommonBloc() : super(const CommonState()) {
    on<SetCategoryEvent>((event, emit) {
      emit(state.copyWith(selectedCategory: event.category));
    });

    on<SetDueDateEvent>((event, emit) {
      emit(state.copyWith(selectedDueDate: event.dueDate));
    });

    on<SetTabIndexEvent>((event, emit) {
      emit(state.copyWith(selectedIndex: event.index));
    });
  }
}
