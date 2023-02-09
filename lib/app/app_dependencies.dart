import 'package:eye_catch/app/app.dart';
import 'package:eye_catch/assets/theme/app_theme.dart';
import 'package:eye_catch/app/game_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EyeCatchAppDependencies extends StatelessWidget {
  const EyeCatchAppDependencies({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => GameRouter(),
        ),
        ChangeNotifierProvider(
          create: (_) => AppThemeWrapper(),
        )
      ],
      child: const EyeCatchApp(),
    );
  }
}
