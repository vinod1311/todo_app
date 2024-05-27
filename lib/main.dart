
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/controller/theme_controller.dart';
import 'package:todo_app/controller/todo_controller.dart';
import 'package:todo_app/screens/splash_screen.dart';
import 'package:todo_app/utils/database/TodoDatabase.dart';
import 'package:todo_app/utils/shared_preferences_helper.dart';
import 'package:todo_app/utils/theme_data_style.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPreferencesHelper.init();

  final todoDatabase = TodoDatabase();
  await todoDatabase.initializeDatabase();

  final themeController = ThemeController();
  await themeController.initTheme();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeController),
        ChangeNotifierProvider(create: (_) => TodoController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  ThemeController themeController = ThemeController();
  @override
  Widget build(BuildContext context) {
    themeController =  Provider.of<ThemeController>(context);
    return ScreenUtilInit(
      designSize: ScreenUtil.defaultSize,
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        title: 'TODO APP',
        debugShowCheckedModeBanner: false,
        theme: ThemeDataStyle.light,
        darkTheme: ThemeDataStyle.dark,
        themeMode: themeController.isDarkMode
            ? ThemeMode.dark
            : ThemeMode.light,
        home: const SplashScreen(),
      ),
    );
  }
}
