import 'package:eye_catch/screens/menu/eye_hunt_menu.dart';
import 'package:eye_catch/screens/menu/eye_hunt_menu_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EyeHuntMenuController(
        context.read(),
      ),
      child: const EyeHuntMenu(),
    );
  }
}
