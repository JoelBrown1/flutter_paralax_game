import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import 'world.dart';
// all the managers - could be conatined in a single import if we used a file that exported all managers
import 'managers/game_manager.dart';
import 'managers/level_manager.dart';

enum Character { dash, sparky }

class DoodleDash extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  DoodleDash({super.children});

  final World _world = World();
  GameManager gameManager = GameManager();
  LevelManager levelManager = LevelManager();

  int screenBufferSpace = 300;

  @override
  Future<void> onLoad() async {
    await add(_world);
    await add(gameManager);
    overlays.add('gameOverlay');
    await add(levelManager);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameManager.isIntro) {
      overlays.add('mainMenuOverlay');
      return;
    }
  }

  @override
  Color BackgroundColor() {
    return const Color.fromARGB(255, 241, 247, 249);
  }

  void initializeGameStart() {
    gameManager.reset();

    // if(children.contains())

    levelManager.reset();
  }
}
