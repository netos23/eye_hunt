import 'package:eye_catch/assets/theme/app_theme.dart';
import 'package:eye_catch/app/game_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EyeCatchApp extends StatelessWidget {
  const EyeCatchApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eye catch',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: context.watch<AppThemeWrapper>().colorScheme,
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  10,
                ),
              ),
            ),
            padding: const EdgeInsets.all(25),
          ),
        ),
      ),
      navigatorKey: context.read<GameRouter>().navigatorKey,
      onGenerateRoute: GameRouter.onGenerateRoute,
    );
  }
}
