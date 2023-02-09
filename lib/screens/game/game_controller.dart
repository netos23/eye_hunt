import 'dart:async';
import 'dart:math';

import 'package:eye_catch/assets/constants/eye_animation.dart';
import 'package:eye_catch/screens/game/transform_descriptions.dart';
import 'package:eye_catch/util/lifecycle_component.dart';
import 'package:eye_catch/util/ticker_providers.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import 'game_settings.dart';

class GamePresentationController extends LifecycleComponent
    with SingleTickerProviderControllerMixin {
  final _random = Random();

  Animation<double> get mainAnimation => _controller.view;

  List<ITransformDescription> _generateDescriptions(int count) {
    final positions = <ITransformDescription>[];
    final step = 1 / count;
    var accStep = step / 2;
    for (int i = 0; i < count; i++) {
      final sign = _random.nextBool() ? -1 : 1;
      final mc = step * _random.nextDouble() / 2;
      positions.add(
        RotationTransformDescription(
          SinTransformDescription(
            IdentityTransform(),
            offset: Offset(
              accStep + mc * sign,
              _random.nextDouble(),
            ),
            phase: _random.nextDouble(),
            amplitude: _random.nextDouble(),
          ),
          phase: _random.nextDouble(),
        ),
      );
      accStep += step;
    }
    return positions;
  }

  final StreamController<bool> _showResult = StreamController.broadcast();
  late final AnimationController _controller;

  Stream<bool> get finished => _showResult.stream;
  final GameSettings settings;
  final eyeControllers = <RiveAnimationController<RuntimeArtboard>>[];
  var positions = <ITransformDescription>[];
  int _eyeCatch = 0;

  GamePresentationController(this.settings);

  @override
  void init() {
    super.init();
    _controller = AnimationController(
      vsync: this,
      duration: settings.duration,
    )
      ..forward()
      ..addStatusListener(_listenAnimation);

    _resetPositions();
    for (int i = 0; i < settings.eyeCount; i++) {
      eyeControllers.add(
        OneShotAnimation(
          EyeAnimations.blink,
          autoplay: false,
          onStop: () => positions[i].visible = false,
        ),
      );
    }
  }


  void _listenAnimation(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _showResult.add(true);
    }
  }

  void replay() {
    _eyeCatch = 0;
    _resetPositions();
    _controller.reset();
    _controller.forward();
  }

  void onEyeTap(int index) {
    eyeControllers[index].isActive = true;
    _eyeCatch++;
  }

  void _resetPositions() {
    _showResult.add(false);
    positions.clear();
    positions = _generateDescriptions(settings.eyeCount);
  }

  @override
  void dispose() {
    for (final c in eyeControllers) {
      c.dispose();
    }
    _controller.removeStatusListener(_listenAnimation);
    _controller.dispose();
    _showResult.close();
    super.dispose();
  }

  String buildStatsView() {
    return 'Catch eyes: $_eyeCatch/${settings.eyeCount}';
  }
}
