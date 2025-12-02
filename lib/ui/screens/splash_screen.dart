import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';
import 'package:task_manager/ui/screens/navbar_screen.dart';
import 'package:task_manager/ui/screens/sign_in_page.dart';
import 'package:task_manager/ui/utlis/assets_location.dart';
import 'package:task_manager/ui/widgets/background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String name = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    splash_screen();
  }

  Future<void> splash_screen() async {
    await Future.delayed(const Duration(seconds: 2));
    bool isLoggedIn = await AuthController.isUserLoggedIn();

    if (isLoggedIn) {
      // Use GetX navigation
      Get.offNamed(NavbarScreen.name);
    } else {
      Get.offNamed(SignIn_page.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background_image(
        child: Center(child: SvgPicture.asset(AssetsLocation.logo)),
      ),
    );
  }
}
