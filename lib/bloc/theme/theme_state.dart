import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

sealed class ThemeState extends Equatable {
  const ThemeState();
}

final class ThemeInitial extends ThemeState {
  @override
  List<Object> get props => [];
}

class ThemeError extends ThemeState{
  final String error;
  const ThemeError(this.error);
  @override
  List<Object?> get props => [error];
}

class ThemeLoaded extends ThemeState{
  final bool isDarkMode;
  final ThemeData themeDataStyle;
  const ThemeLoaded(this.isDarkMode,this.themeDataStyle);

  @override
  List<Object?> get props => [isDarkMode,themeDataStyle];
}