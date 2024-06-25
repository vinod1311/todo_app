import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/utils/preferences.dart';

class SharedPreferencesHelper with Preferences {
  SharedPreferencesHelper._privateConstructor();
  static final SharedPreferencesHelper _instance = SharedPreferencesHelper._privateConstructor();

  static SharedPreferences? _preferences;

  static Future<SharedPreferencesHelper> getInstance() async {
    _preferences ??= await SharedPreferences.getInstance();
    return _instance;
  }

  /// set theme
  Future<void> setThemeMode(bool isDarkMode) async {
    await _preferences?.setBool(Preferences.THEME_MODE_KEY, isDarkMode);
  }

  /// get theme
  Future<bool> getThemeMode() async {
    return _preferences?.getBool(Preferences.THEME_MODE_KEY) ?? false;
  }
}
