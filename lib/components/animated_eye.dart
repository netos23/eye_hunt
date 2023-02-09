import 'package:eye_catch/assets/constants/assets_names.dart';
import 'package:eye_catch/assets/constants/eye_animation.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class AnimatedEye extends StatelessWidget {
  const AnimatedEye({
    Key? key,
    this.width = 100,
    this.height = 100,
    this.onTap,
    required this.controller,
  }) : super(key: key);
  final double width;
  final double height;
  final RiveAnimationController<RuntimeArtboard> controller;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: height,
        child: RiveAnimation.asset(
          AssetNames.eyeAnimation,
          artboard: EyeAnimationBoards.animation,
          controllers: [controller],
        ),
      ),
    );
  }
}
