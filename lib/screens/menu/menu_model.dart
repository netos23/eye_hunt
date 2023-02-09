import 'package:equatable/equatable.dart';

class MenuModel extends Equatable {
  final int eyeCount;
  final int duration;

  const MenuModel({
    required this.eyeCount,
    required this.duration,
  });

  @override
  List<Object?> get props => [eyeCount, duration];
}
