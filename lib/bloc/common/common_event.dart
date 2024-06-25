import 'package:equatable/equatable.dart';

abstract class CommonEvent extends Equatable {
  const CommonEvent();

  @override
  List<Object?> get props => [];
}

class SetCategoryEvent extends CommonEvent {
  final String category;

  const SetCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class SetDueDateEvent extends CommonEvent {
  final String dueDate;

  const SetDueDateEvent(this.dueDate);

  @override
  List<Object?> get props => [dueDate];
}

class SetTabIndexEvent extends CommonEvent {
  final int index;

  const SetTabIndexEvent(this.index);

  @override
  List<Object?> get props => [index];
}
