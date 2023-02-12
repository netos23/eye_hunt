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

  final StreamController<bool> _showResult = StreamController.broadcast();

  @protected
  @visibleForTesting
  late final AnimationController controller;

  final GameSettings settings;
  final eyeControllers = <RiveAnimationController<RuntimeArtboard>>[];

  var positions = <ITransformDescription>[];
  int _eyeCatch = 0;
  final _clicked = <int>{};
  GamePresentationController(this.settings);
  Stream<bool> get finished => _showResult.stream;
  Animation<double> get mainAnimation => controller.view;

  String buildStatsView() {
    return 'Catch eyes: $_eyeCatch/${settings.eyeCount}';
  }

  @override
  void dispose() {
    for (final c in eyeControllers) {
      c.dispose();
    }
    controller.removeStatusListener(_listenAnimation);
    controller.dispose();
    _showResult.close();
    super.dispose();
  }

  @override
  void init() {
    super.init();
    controller = AnimationController(
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

  void onEyeTap(int index) {
    if (_clicked.contains(index)) {
      return;
    }

    eyeControllers[index].isActive = true;
    _eyeCatch++;
    _clicked.add(index);
  }

  void replay() {
    _eyeCatch = 0;
    _resetPositions();
    controller.reset();
    controller.forward();
  }

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

  void _listenAnimation(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _showResult.add(true);
    }
  }

  void _resetPositions() {
    _clicked.clear();
    _showResult.add(false);
    for(final eyeController in eyeControllers){
      eyeController.isActive = false;
    }
    positions.clear();
    positions = _generateDescriptions(settings.eyeCount);
  }
}
