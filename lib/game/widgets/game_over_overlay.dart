import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paralax_game/game/widgets/main_menu_overlay.dart';

import '../doodle_dash.dart';

class GameOverOverlay extends StatelessWidget {
  const GameOverOverlay(this.game, {super.key});
  final Game game;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.background,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Game Over',
                style: Theme.of(context).textTheme.displayMedium!.copyWith(),
              ),
              const WhiteSpace(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  (game as DoodleDash).resetGame();
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(
                    200,
                    75,
                  )),
                  textStyle: MaterialStateProperty.all(
                      Theme.of(context).textTheme.titleLarge),
                ),
                child: const Text('Play Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
