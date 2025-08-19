import 'package:flutter/material.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';

import '../screens/sign_in_page.dart';
import '../screens/update_profile_screen.dart';

class TM_appbar extends StatefulWidget implements PreferredSizeWidget {
  const TM_appbar({super.key});

  @override
  State<TM_appbar> createState() => _TM_appbarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _TM_appbarState extends State<TM_appbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green,
      title: Row(
        children: [
          CircleAvatar(),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: _onTapUpdateScreen,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AuthController.userModel!.firstName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    AuthController.userModel!.email,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () => _onTapLogOutButton(),
            icon: Icon(Icons.logout),
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Future<void> _onTapLogOutButton() async {
    await AuthController.clearData();
    Navigator.pushNamedAndRemoveUntil(
      context,
      SignIn_page.name,
      (predicate) => false,
    );
  }

  void _onTapUpdateScreen() {
    if (ModalRoute.of(context)!.settings.name == UpdateProfileScreen.name) {
      return;
    } else {
      Navigator.pushNamed(context, UpdateProfileScreen.name);
    }
  }
}
