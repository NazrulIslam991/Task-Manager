import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/urls.dart';
import 'package:task_manager/ui/screens/sign_in_page.dart';
import 'package:task_manager/ui/widgets/snake_bar_messege.dart';

import '../widgets/background.dart';
import '../widgets/circular_progress_indicatior.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  static const name = '/Signup';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailEcontroller = TextEditingController();
  TextEditingController _fastNameEcontroller = TextEditingController();
  TextEditingController _lastNameEcontroller = TextEditingController();
  TextEditingController _mobileEcontroller = TextEditingController();
  TextEditingController _passwordEcontroller = TextEditingController();

  bool _SignupInProgress = false;

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
                      "Join With Us",
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
                        if (!EmailValidator.validate(email)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _fastNameEcontroller,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(hintText: "First Name"),
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter your first name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _lastNameEcontroller,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(hintText: "Last Name"),
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter your last name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _mobileEcontroller,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(hintText: "Mobile"),
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter your mobile number';
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
                      visible: !_SignupInProgress,
                      replacement: CenterCircularProgressIndiacator(),
                      child: ElevatedButton(
                        onPressed: SignUpComplete,
                        child: const Icon(
                          Icons.arrow_circle_right_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Center(
                      child: Column(
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "Have account? ",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                letterSpacing: 0.4,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Sign In',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = Signin_page,
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

  void SignUpComplete() {
    if (_formKey.currentState!.validate()) {
      _signUp();
    }
  }

  Future<void> _signUp() async {
    setState(() => _SignupInProgress = true);

    final requestBody = {
      "email": _emailEcontroller.text.trim(),
      "firstName": _fastNameEcontroller.text.trim(),
      "lastName": _lastNameEcontroller.text.trim(),
      "mobile": _mobileEcontroller.text.trim(),
      "password": _passwordEcontroller.text,
    };

    final response = await NetworkCaller.postRequest(
      url: Urls.registationUrl,
      body: requestBody,
    );

    setState(() => _SignupInProgress = false);

    if (response.isSuccess) {
      _clearTextFeild();
      showSnackbarMessage(context, 'Signup Successful');
    } else {
      showSnackbarMessage(context, response.errorMessege ?? 'Signup Failed');
    }
  }

  void _clearTextFeild() {
    _emailEcontroller.clear();
    _fastNameEcontroller.clear();
    _lastNameEcontroller.clear();
    _mobileEcontroller.clear();
    _passwordEcontroller.clear();
  }

  void Signin_page() {
    // Use GetX navigation instead of Navigator
    Get.offNamed(SignIn_page.name);
  }

  @override
  void dispose() {
    _emailEcontroller.dispose();
    _fastNameEcontroller.dispose();
    _lastNameEcontroller.dispose();
    _mobileEcontroller.dispose();
    _passwordEcontroller.dispose();
    super.dispose();
  }
}
