import 'dart:math';

import 'package:flutter/material.dart';

abstract class ITransformDescription {
  bool get visible;

  set visible(bool value);

  Matrix4 performTransform(FlowPaintingContext context, double t, int index);
}

class SinTransformDescription implements ITransformDescription {
  final ITransformDescription parent;
  final Offset offset;
  final double amplitude;
  final double phase;

  @override
  bool get visible => parent.visible;

  @override
  set visible(bool value) => parent.visible = value;

  SinTransformDescription(
    this.parent, {
    required this.offset,
    required this.amplitude,
    required this.phase,
  });

  @override
  Matrix4 performTransform(
    FlowPaintingContext context,
    double t,
    int index,
  ) {
    final childSize = context.getChildSize(index)!;
    final maxAmplitude = amplitude * context.size.width * 0.5;
    final baseDx = maxAmplitude +
        (context.size.width - 2 * maxAmplitude - childSize.width) * offset.dx;
    final timeOffset = maxAmplitude * sin(t * 2 * pi + phase * pi);

    final x = baseDx + timeOffset;

    var pageHeight = context.size.height + childSize.height;
    var elementVerticalOffset = offset.dy * context.size.height;
    final y =
        2 * pageHeight * (1 - t) - childSize.height - elementVerticalOffset;

    return parent.performTransform(context, t, index)..translate(x, y, 0);
  }
}

class RotationTransformDescription implements ITransformDescription {
  final ITransformDescription parent;
  final double amplitude;
  final double phase;

  @override
  bool get visible => parent.visible;

  @override
  set visible(bool value) => parent.visible = value;

  RotationTransformDescription(
    this.parent, {
    this.amplitude = pi / 8,
    this.phase = 0,
  });

  @override
  Matrix4 performTransform(FlowPaintingContext context, double t, int index) {
    return parent.performTransform(context, t, index)
      ..rotateZ(amplitude * sin(t * 2 * pi + phase * pi));
  }
}

class IdentityTransform implements ITransformDescription {
  IdentityTransform({
    this.visible = true,
  });

  @override
  bool visible;

  @override
  Matrix4 performTransform(FlowPaintingContext context, double t, int index) {
    return Matrix4.identity();
  }
}
