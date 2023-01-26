import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const EyeHunt(
        eyeCount: 10,
        duration: Duration(
          seconds: 10,
        ),
      ),
    );
  }
}

class EyeHunt extends StatefulWidget {
  const EyeHunt({
    super.key,
    required this.eyeCount,
    required this.duration,
  });

  final int eyeCount;
  final Duration duration;

  @override
  State<EyeHunt> createState() => _EyeHuntState();
}

class _EyeHuntState extends State<EyeHunt> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final StreamController<bool> _showResult = StreamController.broadcast();
  final _positions = <PositionDescription>[];
  final _controllers = <RiveAnimationController>[];
  final _random = Random();

  int _eyeCatch = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )
      ..forward()
      ..addStatusListener(_listenAnimation);

    for (int i = 0; i < widget.eyeCount; i++) {
      _controllers.add(
        OneShotAnimation(
          'Blink',
          autoplay: false,
          onStop: () => _positions[i].visible = false,
        ),
      );
    }

    _resetPositions();
  }

  void _listenAnimation(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _showResult.add(true);
    }
  }

  void _resetPositions() {
    _showResult.add(false);
    _positions.clear();
    final step = 1 / widget.eyeCount;
    var accStep = step / 2;
    for (int i = 0; i < widget.eyeCount; i++) {
      final sign = _random.nextBool() ? -1 : 1;
      final mc = step * _random.nextDouble() / 2;
      _positions.add(
        PositionDescription(
          offset: Offset(
            accStep + mc * sign,
            _random.nextDouble(),
          ),
          phase: _random.nextDouble(),
          amplitude: _random.nextDouble(),
        ),
      );
      accStep += step;
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    _controller.removeStatusListener(_listenAnimation);
    _showResult.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      body: StreamBuilder(
        stream: _showResult.stream,
        builder: (context, snapshot) {
          final showResult = snapshot.data ?? false;

          if (showResult) {
            return Center(
              child: Text('Catch eyes: $_eyeCatch/${widget.eyeCount}'),
            );
          }

          return Flow(
            delegate: MyFlowDelegate(
              animation: _controller.view,
              positions: _positions,
            ),
            children: [
              for (int i = 0; i < widget.eyeCount; i++)
                GestureDetector(
                  onTap: () {
                    _controllers[i].isActive = true;
                    _eyeCatch++;
                  },
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: RiveAnimation.asset(
                      'assets/eye.riv',
                      artboard: 'Eye Rig - Blink Animation',
                      controllers: [_controllers[i]],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _replay,
        child: const Icon(Icons.replay),
      ),
    );
  }

  void _replay() {
    _eyeCatch = 0;
    _resetPositions();
    _controller.reset();
    _controller.forward();
  }
}

class MyFlowDelegate extends FlowDelegate {
  final Animation<double> animation;
  final List<PositionDescription> positions;

  MyFlowDelegate({
    required this.animation,
    required this.positions,
  }) : super(repaint: animation);

  @override
  void paintChildren(FlowPaintingContext context) {
    final t = animation.value;
    for (int i = 0; i < context.childCount; i++) {
      if(!positions[i].visible){
        continue;
      }

      var matrix4 = Matrix4.identity();

      final childSize = context.getChildSize(i)!;
      final childRelationOffset = positions[i].offset;
      final x = childRelationOffset.dx * context.size.width +
          positions[i].amplitude *
              context.size.width *
              sin(t * 2 * pi + positions[i].phase * pi) -
          childSize.width;
      var pageHeight = context.size.height + childSize.height;
      var elementVerticalOffset = childRelationOffset.dy * context.size.height;
      final y =
          2 * pageHeight * (1 - t) - childSize.height - elementVerticalOffset;

      matrix4.translate(x, y);
      context.paintChild(i, transform: matrix4);
    }
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) {
    return false;
  }
}

class PositionDescription {
  final Offset offset;
  final double amplitude;
  final double phase;
  bool visible;

  PositionDescription({
    this.visible = true,
    required this.offset,
    required this.amplitude,
    required this.phase,
  });
}
