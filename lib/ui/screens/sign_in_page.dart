import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/urls.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';
import 'package:task_manager/ui/screens/forger_password_email_screen.dart';
import 'package:task_manager/ui/screens/navbar_screen.dart';
import 'package:task_manager/ui/screens/sign_up_page.dart';
import 'package:task_manager/ui/widgets/snake_bar_messege.dart';

import '../widgets/background.dart';
import '../widgets/circular_progress_indicatior.dart';

class SignIn_page extends StatefulWidget {
  const SignIn_page({super.key});

  static const name = '/signin'; // <-- fixed

  @override
  State<SignIn_page> createState() => _SignIn_pageState();
}

class _SignIn_pageState extends State<SignIn_page> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailEcontroller = TextEditingController();
  TextEditingController _passwordEcontroller = TextEditingController();
  bool _signinProgressIndicator = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background_image(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 100),
                    Text(
                      "Get Started With",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _emailEcontroller,
                      decoration: InputDecoration(hintText: "Email"),
                      textInputAction: TextInputAction.next,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        String email = value ?? '';
                        if (EmailValidator.validate(email) == false) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordEcontroller,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(hintText: "Password"),
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                      validator: (value) {
                        if ((value?.length ?? 0) <= 6) {
                          return 'Enter a valid password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    Visibility(
                      visible: !_signinProgressIndicator,
                      replacement: CenterCircularProgressIndiacator(),
                      child: ElevatedButton(
                        onPressed: () => _onTapSignin(),
                        child: Icon(
                          Icons.arrow_circle_right_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Center(
                      child: Column(
                        children: [
                          TextButton(
                            onPressed: () => _onTapForgetPassword(),
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                letterSpacing: 0.4,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Sign Up',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = (() => _onTapSignUp()),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSignin() {
    if (_formKey.currentState!.validate()) {
      _signIn();
    }
  }

  Future<void> _signIn() async {
    _signinProgressIndicator = true;
    setState(() {});

    Map<String, String> requestBody = {
      "email": _emailEcontroller.text.trim(),
      "password": _passwordEcontroller.text,
    };

    NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.loginonUrl,
      body: requestBody,
      isFromLogin: true,
    );

    if (response.isSuccess) {
      User userModel = User.fromJson(response.body!['data']);
      String token = response.body!['token'];

      await AuthController.saveUserData(userModel, token);

      // Navigate using GetX
      Get.offAllNamed(NavbarScreen.name);
    } else {
      _signinProgressIndicator = false;
      setState(() {});
      showSnackbarMessage(context, response.errorMessege!);
    }
  }

  void _onTapForgetPassword() {
    // Use GetX navigation
    Get.offNamed(Forgot_Password_Email_Screen.name);
  }

  void _onTapSignUp() {
    // Use GetX navigation
    Get.offNamed(SignUpPage.name);
  }

  @override
  void dispose() {
    _emailEcontroller.dispose();
    _passwordEcontroller.dispose();
    super.dispose();
  }
}
