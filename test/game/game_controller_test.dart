import 'dart:async';

import 'package:eye_catch/screens/game/game_controller.dart';
import 'package:eye_catch/screens/game/game_settings.dart';
import 'package:flutter_test/flutter_test.dart';

// use widget test because animation controller require
// WidgetFlutterBindings initialization
void main() {
  group("Lifecycle tests", () {
    testWidgets("Ensure initialized", (_) async {
      const duration = 10;
      const eyeCount = 10;
      const settings = GameSettings(
        eyeCount: eyeCount,
        duration: Duration(
          seconds: duration,
        ),
      );
      final controller = GamePresentationController(settings);

      controller.init();

      expect(controller.controller.isAnimating, equals(true));
      expect(controller.positions.length, equals(eyeCount));
      expect(controller.eyeControllers.length, equals(eyeCount));
      for (final eyeController in controller.eyeControllers) {
        expect(eyeController.isActive, equals(false));
      }

      controller.dispose();
    });
  });

  group("Game logic tests", () {
    testWidgets("Ensure single eye click ", (_) async {
      const duration = 1;
      const eyeCount = 10;
      const settings = GameSettings(
        eyeCount: eyeCount,
        duration: Duration(
          seconds: duration,
        ),
      );

      final controller = GamePresentationController(settings);
      controller.init();

      for (int i = 0; i < eyeCount; i++) {
        controller.onEyeTap(i);
      }

      expect(
        controller.buildStatsView(),
        equals('Catch eyes: ${settings.eyeCount}/${settings.eyeCount}'),
      );

      controller.dispose();
    });
    testWidgets("Ensure no eye click success finished", (_) async {
      const duration = 1;
      const eyeCount = 10;
      const settings = GameSettings(
        eyeCount: eyeCount,
        duration: Duration(
          seconds: duration,
        ),
      );

      final controller = GamePresentationController(settings);
      controller.init();

      expect(
        controller.buildStatsView(),
        equals('Catch eyes: 0/${settings.eyeCount}'),
      );

      controller.dispose();
    });

    testWidgets("Ensure double click protection", (_) async {
      const duration = 1;
      const eyeCount = 10;
      const settings = GameSettings(
        eyeCount: eyeCount,
        duration: Duration(
          seconds: duration,
        ),
      );

      final controller = GamePresentationController(settings);
      controller.init();

      for (int i = 0; i < eyeCount; i++) {
        controller.onEyeTap(i);
        controller.onEyeTap(i);
      }

      expect(
        controller.buildStatsView(),
        equals('Catch eyes: ${settings.eyeCount}/${settings.eyeCount}'),
      );

      controller.dispose();
    });
  });
}
