import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utlis/assets_location.dart';

class Background_image extends StatelessWidget {
  const Background_image({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SvgPicture.asset(
            AssetsLocation.background,
            fit: BoxFit.cover,
            height: double.maxFinite,
            width: double.maxFinite,
          ),
          child,
        ],
      ),
    );
  }
}
