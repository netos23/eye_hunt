import 'package:eye_catch/screens/game/game_settings.dart';
import 'package:eye_catch/screens/menu/eye_hunt_menu_controller.dart';
import 'package:eye_catch/screens/menu/menu_model.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../util/listenable_tester.dart';
import '../util/mocks.dart';

void main() {
  group("Menu model change tests", () {
    test("Check that the duration changes and the quantity does not change",
        () {
      final gameRouter = GameRouterMock();
      final listenableTester = ListenableTester();
      const initialState = MenuModel(
        eyeCount: 10,
        duration: 1,
      );
      const expectedState = MenuModel(
        eyeCount: 10,
        duration: 10,
      );

      final controller = EyeHuntMenuController(
        router: gameRouter,
        initialModel: initialState,
      );

      controller.addListener(listenableTester);
      controller.changeDuration(10);
      controller.removeListener(listenableTester);

      listenableTester.expectCalls();
      verifyZeroInteractions(gameRouter);
      expect(controller.value, equals(expectedState));
    });

    test("Check that the quantity changes and the duration does not change",
        () {
      final gameRouter = GameRouterMock();
      final listenableTester = ListenableTester();
      const initialState = MenuModel(
        eyeCount: 1,
        duration: 10,
      );
      const expectedState = MenuModel(
        eyeCount: 10,
        duration: 10,
      );

      final controller = EyeHuntMenuController(
        router: gameRouter,
        initialModel: initialState,
      );
      controller.addListener(listenableTester);
      controller.changeEyeCount({10});
      controller.removeListener(listenableTester);

      listenableTester.expectCalls();
      verifyZeroInteractions(gameRouter);
      expect(controller.value, equals(expectedState));
    });

    test("Check that the quantity changes and the duration changes", () {
      final gameRouter = GameRouterMock();
      final listenableTester = ListenableTester();
      const initialState = MenuModel(
        eyeCount: 1,
        duration: 5,
      );
      const expectedState = MenuModel(
        eyeCount: 10,
        duration: 10,
      );

      final controller = EyeHuntMenuController(
        router: gameRouter,
        initialModel: initialState,
      );

      controller.addListener(listenableTester);
      controller.value = expectedState;
      controller.removeListener(listenableTester);

      listenableTester.expectCalls();
      verifyZeroInteractions(gameRouter);
      expect(controller.value, equals(expectedState));
    });
  });

  group("Navigation tests", () {
    test("Test game starts", () async {
      final gameRouter = GameRouterMock();
      const eyeCount = 10;
      const duration = 10;

      const menuModel = MenuModel(
        eyeCount: eyeCount,
        duration: duration,
      );

      const settings = GameSettings(
        eyeCount: eyeCount,
        duration: Duration(
          seconds: duration,
        ),
      );

      when(() => gameRouter.toGame(settings)).thenAnswer((_) async {});

      final controller = EyeHuntMenuController(
        router: gameRouter,
        initialModel: menuModel,
      );

      await controller.play();

      verify(() => gameRouter.toGame(settings)).called(1);
    });
  });
}
