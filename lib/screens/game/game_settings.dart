import 'package:equatable/equatable.dart';

class GameSettings extends Equatable {
  final int eyeCount;
  final Duration duration;

  const GameSettings({
    required this.eyeCount,
    required this.duration,
  });

  @override
  List<Object> get props => [eyeCount, duration];
}
