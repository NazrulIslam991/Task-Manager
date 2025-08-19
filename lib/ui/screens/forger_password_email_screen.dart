import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/email_verification_page.dart';
import 'package:task_manager/ui/screens/sign_in_page.dart';
import 'package:task_manager/ui/widgets/background.dart';

class Forgot_Password_Email_Screen extends StatefulWidget {
  const Forgot_Password_Email_Screen({super.key});
  static const name = '/Forgot Password email screen';

  @override
  State<Forgot_Password_Email_Screen> createState() =>
      _Forgot_Password_Email_ScreenState();
}

class _Forgot_Password_Email_ScreenState
    extends State<Forgot_Password_Email_Screen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController _emailEController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background_image(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 100),
                    Text(
                      "Your Email Address",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(right: 90),
                      child: Text(
                        "A 6 digit verification pin will send to your email address",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Email'),
                      controller: _emailEController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        String email = value ?? '';
                        if (EmailValidator.validate(email) == false) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: () => emailValidation(),
                      child: Icon(
                        Icons.arrow_circle_right_outlined,
                        color: Colors.white,
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
                                    ..onTap = (() => Signin_page()),
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

  void emailValidation() {
    if (_formkey.currentState!.validate()) {
      Navigator.pushReplacementNamed(context, EmailVerificationPage.name);
    }
  }

  void Signin_page() {
    Navigator.pushReplacementNamed(context, SignIn_page.name);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailEController.dispose();
  }
}
