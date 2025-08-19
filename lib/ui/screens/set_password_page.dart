import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/sign_in_page.dart';

import '../widgets/background.dart';

class SetPasswordPage extends StatefulWidget {
  const SetPasswordPage({super.key});

  static const name = '/SetPassword';

  @override
  State<SetPasswordPage> createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends State<SetPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _passwordEC = TextEditingController();
  TextEditingController _confirmPasswordEC = TextEditingController();

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
                      "Set Password",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(right: 45),
                      child: Text(
                        "Minimum length password 8 character with Letter and Number combination",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    SizedBox(height: 20),

                    TextFormField(
                      controller: _passwordEC,
                      decoration: InputDecoration(hintText: "Password"),
                      textInputAction: TextInputAction.next,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if ((value?.length ?? 0) <= 6) {
                          return 'Enter a valid password';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 20),

                    TextFormField(
                      controller: _confirmPasswordEC,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(hintText: "Confrim Password"),
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if ((value?.length ?? 0) <= 6) {
                          return 'Enter a valid password';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: () => Return_Signin_page(),
                      child: Text("Confirm"),
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
                                    ..onTap = (() => Return_Signin_page()),
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

  void Return_Signin_page() {
    Navigator.pushReplacementNamed(context, SignIn_page.name);
  }
}
