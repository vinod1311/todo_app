import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/screens/home_screen.dart';

import '../utils/assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Timer? timer;

  // SharedPrefUtils sharedPrefUtils =SharedPrefUtils();

  @override
  void initState() {
    super.initState();
    timer?.cancel();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp){
      navigateToHome(context);
    });
  }

  /// navigating to home screen
  void navigateToHome(BuildContext context) async {
    timer = Timer(
      const Duration(seconds: 3),
          () async{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: ( (context) =>const HomeScreen() )));
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo or title
            Image.asset(Assets.splashImage, width: 250.w, height: 250.h),
            SizedBox(height: 20.h),
            Text(
              'Todo App',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            // Loading indicator
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}