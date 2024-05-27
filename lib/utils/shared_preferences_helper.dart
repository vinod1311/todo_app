import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/utils/preferences.dart';

class SharedPreferencesHelper with Preferences{

  static late final SharedPreferences instance;

  /// pref initialize
  static Future<SharedPreferences> init() async =>
      instance = await SharedPreferences.getInstance();

  /// set theme
  static Future<void> setThemeMode(bool isDarkMode) async {
    instance.setBool(Preferences.THEME_MODE_KEY, isDarkMode);
  }

  /// get theme
  static Future<bool> getThemeMode() async {
    return instance.getBool(Preferences.THEME_MODE_KEY) ?? false;
  }

}
