
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/bloc/common/common_bloc.dart';
import 'package:todo_app/bloc/common/common_event.dart';
import 'package:todo_app/bloc/theme/theme_bloc.dart';
import 'package:todo_app/bloc/todo/todo_bloc.dart';
import 'package:todo_app/repository/todo/repository/todo_repository_builder.dart';
import 'package:todo_app/screens/splash_screen.dart';
import 'package:todo_app/utils/database/TodoDatabase.dart';
import 'package:todo_app/utils/shared_preferences_helper.dart';
import 'package:todo_app/utils/theme_data_style.dart';

import 'bloc/theme/theme_event.dart';
import 'bloc/theme/theme_state.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferencesHelper = await SharedPreferencesHelper.getInstance();

  final todoDatabase = TodoDatabase();
  await todoDatabase.initializeDatabase();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<TodoBloc>(
          create: (context) =>  TodoBloc(TodoRepositoryBuilder.repository()),
        ),
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc(sharedPreferencesHelper)..add(LoadThemeEvent()),
        ),
        BlocProvider<CommonBloc>(
          create: (context) => CommonBloc(),
        ),
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
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: ScreenUtil.defaultSize,
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        title: 'TODO APP',
        debugShowCheckedModeBanner: false,
        theme: ThemeDataStyle.light,
        darkTheme: ThemeDataStyle.dark,
        themeMode: ThemeMode.light,
        home: const SplashScreen(),
      ),
    );
  }
}
