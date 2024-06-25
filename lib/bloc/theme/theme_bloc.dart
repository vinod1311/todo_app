import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/theme/theme_event.dart';
import 'package:todo_app/bloc/theme/theme_state.dart';
import 'package:todo_app/utils/shared_preferences_helper.dart';
import 'package:todo_app/utils/theme_data_style.dart';


class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPreferencesHelper sharedPreferencesHelper;

  ThemeBloc(this.sharedPreferencesHelper) : super(ThemeInitial()) {
    on<ToggleThemeEvent>(_onToggleTheme);
    on<LoadThemeEvent>(_onLoadTheme);

  }



  void _onToggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) async {
    try {
      final bool isDarkMode = !(await sharedPreferencesHelper.getThemeMode());
      await sharedPreferencesHelper.setThemeMode(isDarkMode);
      final themeData = isDarkMode ? ThemeDataStyle.dark : ThemeDataStyle.light;
      emit(ThemeLoaded(isDarkMode,themeData));
    } catch (error) {
      emit(ThemeError(error.toString()));
    }
  }

  void _onLoadTheme(LoadThemeEvent event, Emitter<ThemeState> emit) async {
    try {
      final isDarkMode = await sharedPreferencesHelper.getThemeMode();
      final themeData = isDarkMode ? ThemeDataStyle.dark : ThemeDataStyle.light;
      emit(ThemeLoaded(isDarkMode,themeData));
    } catch (error) {
      emit(ThemeError(error.toString()));
    }
  }
}
