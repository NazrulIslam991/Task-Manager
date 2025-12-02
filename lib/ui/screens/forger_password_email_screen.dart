import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/email_verification_page.dart';
import 'package:task_manager/ui/screens/sign_in_page.dart';
import 'package:task_manager/ui/widgets/background.dart';

class Forgot_Password_Email_Screen extends StatefulWidget {
  const Forgot_Password_Email_Screen({super.key});
  static const name = '/forgot_password_email';

  @override
  State<Forgot_Password_Email_Screen> createState() =>
      _Forgot_Password_Email_ScreenState();
}

class _Forgot_Password_Email_ScreenState
    extends State<Forgot_Password_Email_Screen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background_image(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 100),
                    Text(
                      "Your Email Address",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(right: 90),
                      child: Text(
                        "A 6 digit verification pin will be sent to your email address",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(hintText: 'Email'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || !EmailValidator.validate(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _validateEmailAndProceed,
                      child: const Icon(
                        Icons.arrow_circle_right_outlined,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: "Have an account? ",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            letterSpacing: 0.4,
                          ),
                          children: [
                            TextSpan(
                              text: 'Sign In',
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w700,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = _navigateToSignIn,
                            ),
                          ],
                        ),
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

  void _validateEmailAndProceed() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacementNamed(context, EmailVerificationPage.name);
    }
  }

  void _navigateToSignIn() {
    Navigator.pushReplacementNamed(context, SignIn_page.name);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
