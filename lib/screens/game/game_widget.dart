import 'package:eye_catch/components/animated_eye.dart';
import 'package:eye_catch/screens/game/animated_transform_render.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'game_controller.dart';

class EyeHuntGame extends StatelessWidget {
  const EyeHuntGame({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<GamePresentationController>();
    return Scaffold(
      body: StreamBuilder(
        stream: controller.finished,
        builder: (context, snapshot) {
          final showResult = snapshot.data ?? false;

          if (showResult) {
            return Center(
              child: Text(controller.buildStatsView()),
            );
          }

          return Flow(
            delegate: AnimatedTransformsDelegate(
              animation: controller.mainAnimation,
              positions: controller.positions,
            ),
            children: [
              for (int i = 0; i < controller.settings.eyeCount; i++)
                AnimatedEye(
                  controller: controller.eyeControllers[i],
                  onTap: () => controller.onEyeTap(i),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.replay,
        child: const Icon(Icons.replay),
      ),
    );
  }
}
