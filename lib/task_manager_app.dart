import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
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
      initialRoute: SplashScreen.name,
      getPages: [
        GetPage(name: SplashScreen.name, page: () => SplashScreen()),
        GetPage(name: SignIn_page.name, page: () => SignIn_page()),
        GetPage(
          name: Forgot_Password_Email_Screen.name,
          page: () => Forgot_Password_Email_Screen(),
        ),
        GetPage(name: SignUpPage.name, page: () => SignUpPage()),
        GetPage(
          name: EmailVerificationPage.name,
          page: () => EmailVerificationPage(),
        ),
        GetPage(name: SetPasswordPage.name, page: () => SetPasswordPage()),
        GetPage(name: AddNewTaskScreen.name, page: () => AddNewTaskScreen()),
        GetPage(name: NavbarScreen.name, page: () => NavbarScreen()),
        GetPage(
          name: UpdateProfileScreen.name,
          page: () => UpdateProfileScreen(),
        ),
      ],
    );
  }
}
