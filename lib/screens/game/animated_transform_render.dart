import 'package:eye_catch/screens/game/transform_descriptions.dart';
import 'package:flutter/material.dart';

typedef TransformObserver = void Function(
  FlowPaintingContext context,
  int index,
  Matrix4 transform,
);

class AnimatedTransformsDelegate extends FlowDelegate {
  final Animation<double> animation;
  final List<ITransformDescription> positions;
  final TransformObserver? transformObserver;

  AnimatedTransformsDelegate({
    required this.animation,
    required this.positions,
    this.transformObserver,
  }) : super(repaint: animation);

  @override
  void paintChildren(FlowPaintingContext context) {
    final t = animation.value;
    for (int i = 0; i < context.childCount; i++) {
      if (!positions[i].visible) {
        continue;
      }

      final transform = positions[i].performTransform(context, t, i);
      transformObserver?.call(context, i, transform);
      context.paintChild(i, transform: transform);
    }
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) {
    return false;
  }
}
