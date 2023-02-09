import 'package:eye_catch/screens/game/game_controller.dart';
import 'package:eye_catch/screens/game/game_settings.dart';
import 'package:eye_catch/screens/game/game_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({
    Key? key,
    required this.settings,
  }) : super(key: key);

  final GameSettings settings;

  @override
  Widget build(BuildContext context) {
    return Provider(
      lazy: false,
      create: (_) => GamePresentationController(settings)..init(),
      dispose: (_, c) => c.dispose(),
      child: const EyeHuntGame(),
    );
  }
}
