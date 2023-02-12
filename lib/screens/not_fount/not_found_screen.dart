import 'package:eye_catch/app/game_router.dart';
import 'package:eye_catch/components/bouncing_eye.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Flexible(
              flex: 10,
              child: SizedBox(
                height: 400,
                child: BouncingEye(),
              ),
            ),
            const Spacer(),
            Flexible(
              flex: 3,
              child: Text(
                'Page not found',
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            const Spacer(),
            Flexible(
              flex: 3,
              child: FilledButton(
                onPressed: context.read<GameRouter>().toMenu,
                child: const Text('Menu'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
