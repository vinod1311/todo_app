import 'package:equatable/equatable.dart';

class CommonState extends Equatable {
  final String selectedCategory;
  final String? selectedDueDate;
  final int selectedIndex;

  const CommonState({
    this.selectedCategory = 'personal',
    this.selectedDueDate,
    this.selectedIndex = 0,
  });

  CommonState copyWith({
    String? selectedCategory,
    String? selectedDueDate,
    int? selectedIndex,
  }) {
    return CommonState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedDueDate: selectedDueDate ?? this.selectedDueDate,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  List<Object?> get props => [selectedCategory, selectedDueDate, selectedIndex];
}
