import 'package:flutter_test/flutter_test.dart';

class ListenableTester {
  ListenableTester();

  int _calls = 0;

  void call() {
    _calls++;
  }

  void reset() {
    _calls = 0;
  }

  void expectCalls([int count = 1]) {
    expect(_calls, equals(count));
  }

  void expectZeroInteraction() {
    expect(_calls, equals(0));
  }
}
