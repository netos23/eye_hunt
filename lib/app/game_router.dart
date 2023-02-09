import 'package:eye_catch/app/app_routes.dart';
import 'package:eye_catch/screens/game/game_screen.dart';
import 'package:eye_catch/screens/game/game_widget.dart';
import 'package:eye_catch/screens/game/game_settings.dart';
import 'package:eye_catch/screens/menu/menu_screen.dart';
import 'package:eye_catch/screens/not_fount/not_found_screen.dart';
import 'package:flutter/material.dart';

class GameRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.menu:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const MenuScreen(),
        );
      case AppRoutes.game:
        final arguments = settings.arguments;
        if (arguments is! GameSettings) {
          return MaterialPageRoute(
            builder: (_) => const NotFoundScreen(),
          );
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => GameScreen(
            settings: arguments,
          ),
        );
    }

    return MaterialPageRoute(
      settings: settings,
      builder: (_) => const NotFoundScreen(),
    );
  }

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  Future<void> toGame(GameSettings settings) async {
    await navigatorKey.currentState?.pushNamed(
      AppRoutes.game,
      arguments: settings,
    );
  }

  Future<void> toMenu() async {
    await navigatorKey.currentState?.pushReplacementNamed(
      AppRoutes.menu,
    );
  }

  Future<void> maybePop() async {
    await navigatorKey.currentState?.maybePop();
  }
}
