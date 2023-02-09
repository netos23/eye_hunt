import 'package:eye_catch/assets/constants/assets_names.dart';
import 'package:eye_catch/assets/constants/eye_animation.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class BouncingEye extends StatefulWidget {
  const BouncingEye({
    super.key,
  });

  @override
  State<BouncingEye> createState() => _BouncingEyeState();
}

class _BouncingEyeState extends State<BouncingEye>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 2,
      ),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AlignTransition(
      alignment: Tween(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).animate(_controller),
      child: const SizedBox(
        height: 200,
        width: 200,
        child: RiveAnimation.asset(
          AssetNames.eyeAnimation,
          artboard: EyeAnimationBoards.oneSideClosed,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
