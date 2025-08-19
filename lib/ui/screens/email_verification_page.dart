import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart'
    show PinCodeTextField, AnimationType, PinTheme, PinCodeFieldShape;
import 'package:task_manager/ui/screens/forger_password_email_screen.dart';
import 'package:task_manager/ui/screens/set_password_page.dart';
import 'package:task_manager/ui/widgets/background.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  static const name = '/email_verification';

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _otpEController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background_image(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 55, right: 55),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 140),
                    Text(
                      "Pin Verification",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(right: 45),
                      child: Text(
                        "A 6 digit verification pin will send to your email address",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    SizedBox(height: 20),

                    Container(
                      height: 60,
                      width: double.infinity,
                      child: PinCodeTextField(
                        length: 6,
                        obscureText: false,
                        animationType: AnimationType.fade,
                        keyboardType: TextInputType.number,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 50,
                          fieldWidth: 40,
                          activeFillColor: Colors.white,
                          selectedColor: Colors.green,
                          inactiveColor: Colors.grey,
                        ),
                        animationDuration: Duration(milliseconds: 300),
                        backgroundColor: Colors.transparent,
                        enableActiveFill: true,
                        controller: _otpEController,
                        onCompleted: (v) {
                          print("Completed");
                        },

                        appContext: context,
                      ),
                    ),

                    SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: () => SetPassword(),
                      child: Text("verify"),
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
                                  text: 'Sign Up',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = (() => SignUp()),
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

  void SignUp() {
    Navigator.pushReplacementNamed(context, Forgot_Password_Email_Screen.name);
  }

  void SetPassword() {
    Navigator.pushReplacementNamed(context, SetPasswordPage.name);
  }
}
