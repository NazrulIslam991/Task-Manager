import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/add_new_task_screen.dart';
import 'package:task_manager/ui/screens/email_verification_page.dart';
import 'package:task_manager/ui/screens/forger_password_email_screen.dart';
import 'package:task_manager/ui/screens/navbar_screen.dart';
import 'package:task_manager/ui/screens/set_password_page.dart';
import 'package:task_manager/ui/screens/sign_in_page.dart';
import 'package:task_manager/ui/screens/sign_up_page.dart';
import 'package:task_manager/ui/screens/splash_screen.dart';
import 'package:task_manager/ui/screens/update_profile_screen.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  static GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //navigatorKey: navigator,
      theme: ThemeData(
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
          titleSmall: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: Colors.grey,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.grey),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
          errorBorder: OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            fixedSize: Size.fromWidth(double.maxFinite),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Colors.green),
        ),
      ),
      initialRoute: '/',
      routes: {
        SplashScreen.name: (context) => SplashScreen(),
        SignIn_page.name: (context) => SignIn_page(),
        Forgot_Password_Email_Screen.name: (context) =>
            Forgot_Password_Email_Screen(),
        SignUpPage.name: (context) => SignUpPage(),
        EmailVerificationPage.name: (context) => EmailVerificationPage(),
        SetPasswordPage.name: (context) => SetPasswordPage(),
        AddNewTaskScreen.name: (context) => AddNewTaskScreen(),
        NavbarScreen.name: (context) => NavbarScreen(),
        UpdateProfileScreen.name: (context) => UpdateProfileScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
