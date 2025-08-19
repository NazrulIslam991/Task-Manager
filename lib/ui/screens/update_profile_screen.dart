import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/urls.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';
import 'package:task_manager/ui/widgets/app_bar.dart';
import 'package:task_manager/ui/widgets/circular_progress_indicatior.dart';
import 'package:task_manager/ui/widgets/snake_bar_messege.dart';

import '../widgets/background.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  static const name = '/UpdateProfileScreen';

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailEcontroller = TextEditingController();
  TextEditingController _fastNameEcontroller = TextEditingController();
  TextEditingController _lastNameEcontroller = TextEditingController();
  TextEditingController _mobileEcontroller = TextEditingController();
  TextEditingController _passwordEcontroller = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;

  bool _UpdateProfileInProgress = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailEcontroller.text = AuthController.userModel?.email ?? '';
    _fastNameEcontroller.text = AuthController.userModel?.firstName ?? '';
    _lastNameEcontroller.text = AuthController.userModel?.lastName ?? '';
    _mobileEcontroller.text = AuthController.userModel?.mobile ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TM_appbar(),
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
                      "Update Profile",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                    SizedBox(height: 20),

                    _PhotoPicker_InputFeild(),
                    SizedBox(height: 20),

                    TextFormField(
                      controller: _emailEcontroller,
                      decoration: InputDecoration(hintText: "Email"),
                      textInputAction: TextInputAction.next,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),

                    SizedBox(height: 20),

                    TextFormField(
                      controller: _fastNameEcontroller,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(hintText: "First Name"),
                      textInputAction: TextInputAction.done,
                      validator: (String? value) {
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
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter your Last name';
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
                      validator: (String? value) {
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
                      validator: (value) {
                        int length = value?.length ?? 0;
                        if (length > 0 && length <= 6) {
                          return 'Enter a  password more than 7 letters';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 16),

                    Visibility(
                      visible: _UpdateProfileInProgress == false,
                      replacement: CenterCircularProgressIndiacator(),
                      child: ElevatedButton(
                        onPressed: () => _UpdateProfileComplete(),
                        child: Icon(
                          Icons.arrow_circle_right_outlined,
                          color: Colors.white,
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

  Widget _PhotoPicker_InputFeild() {
    return GestureDetector(
      onTap: _PickPhoto,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  topLeft: Radius.circular(8),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                "Photo",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(width: 10),
            Text(
              _selectedImage == null ? "Select Image" : _selectedImage!.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _UpdateProfileComplete() {
    if (_formKey.currentState!.validate()) {
      _UpdateProfile();
    }
  }

  Future<void> _UpdateProfile() async {
    _UpdateProfileInProgress = true;

    if (mounted) {
      setState(() {});
    }

    Map<String, String> requestBody = {
      "email": _emailEcontroller.text.trim(),
      "firstName": _fastNameEcontroller.text.trim(),
      "lastName": _lastNameEcontroller.text.trim(),
      "mobile": _mobileEcontroller.text.trim(),
    };

    if (_passwordEcontroller.text.isNotEmpty) {
      requestBody['password'] = _passwordEcontroller.text;
    }
    if (_selectedImage != null) {
      Uint8List imageBytes = await _selectedImage!.readAsBytes();
      requestBody['photo'] = base64Encode(imageBytes);
    }

    NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.profileUpdateUrl,
      body: requestBody,
    );

    _UpdateProfileInProgress = false;
    if (mounted) {
      setState(() {});
    }

    if (response.isSuccess) {
      _passwordEcontroller.clear();
      if (mounted) {
        showSnackbarMessage(context, "Update successfully");
      }
    } else {
      if (mounted) {
        showSnackbarMessage(context, response.errorMessege!);
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailEcontroller.dispose();
    _fastNameEcontroller.dispose();
    _lastNameEcontroller.dispose();
    _mobileEcontroller.dispose();
    _passwordEcontroller.dispose();
  }

  Future<void> _PickPhoto() async {
    final XFile? pickedImage = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      _selectedImage = pickedImage;
      setState(() {});
    }
  }
}
