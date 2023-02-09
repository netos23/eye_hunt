import 'package:eye_catch/util/theme_extensions.dart';
import 'package:flutter/material.dart';

class AppThemeWrapper extends ChangeNotifier {
  final lightColorScheme = ColorScheme.light(
    background: Colors.deepPurple[200]!,
    secondaryContainer: Colors.deepPurple[400],
    onSecondaryContainer: Colors.white,
  );
  final darkColorScheme = ColorScheme.dark(
    secondaryContainer: Colors.deepPurple[400],
    onSecondaryContainer: Colors.white,
  );

  AppThemeWrapper({
    Brightness brightness = Brightness.light,
  }) : _brightness = brightness;

  Brightness _brightness;

  ColorScheme get colorScheme =>
      _brightness.isLight ? lightColorScheme : darkColorScheme;

  set brightness(Brightness value) {
    if (_brightness != value) {
      _brightness = value;
      notifyListeners();
    }
  }

  Brightness get brightness => _brightness;

  void toggleTheme() {
    _brightness = _brightness.invert;
    notifyListeners();
  }
}
