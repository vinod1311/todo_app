import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../utils/shared_preferences_helper.dart';
import '../utils/theme_data_style.dart';

class ThemeController extends ChangeNotifier {
  ThemeData _themeDataStyle = ThemeDataStyle.light;
  bool _isDarkMode = false;

  ThemeData get themeDataStyle => _themeDataStyle;
  bool get isDarkMode => _isDarkMode;

  Future<void> initTheme(Brightness brightness) async {
    _isDarkMode = await SharedPreferencesHelper.getThemeMode();
    _themeDataStyle = _isDarkMode ? ThemeDataStyle.dark : ThemeDataStyle.light;

    if (brightness == Brightness.dark) {
      _isDarkMode = true;
      _themeDataStyle = ThemeDataStyle.dark;
    } else {
      _isDarkMode = false;
      _themeDataStyle = ThemeDataStyle.light;
    }
    await SharedPreferencesHelper.setThemeMode(_isDarkMode);
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    SharedPreferencesHelper.setThemeMode(_isDarkMode);
    _themeDataStyle = _isDarkMode ? ThemeDataStyle.dark : ThemeDataStyle.light;
    notifyListeners();
  }
}
