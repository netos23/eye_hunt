import 'package:eye_catch/app/game_router.dart';
import 'package:eye_catch/screens/game/game_settings.dart';
import 'package:eye_catch/screens/menu/menu_model.dart';
import 'package:flutter/foundation.dart';

class EyeHuntMenuController extends ValueNotifier<MenuModel> {
  final GameRouter router;

  EyeHuntMenuController(
    this.router,
  ) : super(const MenuModel(eyeCount: 5, duration: 5));

  void changeDuration(double nextDuration) {
    final duration = nextDuration.toInt();
    value = MenuModel(
      eyeCount: value.eyeCount,
      duration: duration,
    );
  }

  void changeEyeCount(Set<int> eyeCount) {
    value = MenuModel(
      eyeCount: eyeCount.first,
      duration: value.duration,
    );
  }

  Future<void> play() async {
    await router.toGame(
      GameSettings(
        eyeCount: value.eyeCount,
        duration: Duration(seconds: value.duration),
      ),
    );
  }
}
