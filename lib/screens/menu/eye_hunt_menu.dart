import 'package:eye_catch/assets/theme/app_theme.dart';
import 'package:eye_catch/components/bouncing_eye.dart';
import 'package:eye_catch/screens/menu/eye_hunt_menu_controller.dart';
import 'package:eye_catch/util/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EyeHuntMenu extends StatelessWidget {
  const EyeHuntMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.read<EyeHuntMenuController>();

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Flexible(
              flex: 15,
              child: BouncingEye(),
            ),
            Flexible(
              flex: 4,
              child: FittedBox(
                child: Text(
                  'Eye hunt',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
            ),
            const Spacer(),
            const Flexible(
              flex: 2,
              child: Text(
                'Eye count',
              ),
            ),
            const Spacer(),
            const Flexible(
              flex: 3,
              child: _EyeCountSegmentButton(),
            ),
            const Spacer(),
            const Flexible(
              flex: 2,
              child: Text(
                'Game difficulty',
              ),
            ),
            const Flexible(
              flex: 3,
              child: _GameDifficultySlider(),
            ),
            const Spacer(),
            Flexible(
              flex: 4,
              child: FilledButton(
                onPressed: controller.play,
                child: const Icon(
                  Icons.play_arrow,
                ),
              ),
            ),
            const Spacer(
              flex: 1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: context.read<AppThemeWrapper>().toggleTheme,
        child: Icon(
          context.watch<AppThemeWrapper>().brightness.isLight
              ? Icons.dark_mode
              : Icons.light_mode,
        ),
      ),
    );
  }
}

class _GameDifficultySlider extends StatelessWidget {
  const _GameDifficultySlider();

  @override
  Widget build(BuildContext context) {
    final controller = context.read<EyeHuntMenuController>();
    return SizedBox(
      width: 400,
      child: Slider(
        value: context.select<EyeHuntMenuController, double>(
          (c) => c.value.duration.toDouble(),
        ),
        min: 5.0,
        max: 25.0,
        divisions: 10,
        onChanged: controller.changeDuration,
      ),
    );
  }
}

class _EyeCountSegmentButton extends StatelessWidget {
  const _EyeCountSegmentButton();

  @override
  Widget build(BuildContext context) {
    final controller = context.read<EyeHuntMenuController>();

    return SegmentedButton<int>(
      segments: List.generate(
        5,
        (index) {
          final value = index + 5;
          return ButtonSegment<int>(
            value: value,
            label: Text(value.toString()),
          );
        },
      ),
      selected: {
        context.select<EyeHuntMenuController, int>(
          (c) => c.value.eyeCount,
        ),
      },
      onSelectionChanged: controller.changeEyeCount,
    );
  }
}
