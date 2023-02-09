import 'dart:ui';

extension BrightnessPredicates on Brightness {
  bool get isLight => this == Brightness.light;

  bool get isDark => !isLight;
}

extension BrightnessToggle on Brightness {
  Brightness get invert => isLight ? Brightness.dark : Brightness.light;
}
