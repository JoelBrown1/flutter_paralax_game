import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import 'world.dart';
// all the managers - could be conatined in a single import if we used a file that exported all managers
import 'managers/game_manager.dart';
import 'managers/level_manager.dart';
import 'managers/object_manager.dart';

enum Character { dash, sparky }

class DoodleDash extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  DoodleDash({super.children});

  final World _world = World();
  GameManager gameManager = GameManager();
  LevelManager levelManager = LevelManager();
  ObjectManager objectManager = ObjectManager();

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

    if (gameManager.isPlaying) {
      checkLevelUp();
    }
  }

  @override
  Color BackgroundColor() {
    return const Color.fromARGB(255, 241, 247, 249);
  }

  void initializeGameStart() {
    gameManager.reset();

    if (children.contains(objectManager)) objectManager.removeFromParent();

    levelManager.reset();

    objectManager = ObjectManager(
      minVerticalDistanceToNextPlatform: levelManager.minDistance,
      maxVerticalDistanceToNextPlatform: levelManager.maxDistance,
    );

    add(objectManager);

    objectManager.configure(levelManager.level, levelManager.difficulty);
  }

  void setCharacter() {}

  void startGame() {
    initializeGameStart();
    print('removeing mainMenuOverlay');
    gameManager.state = GameState.playing;
    overlays.remove('mainMenuOverlay');
  }

  void resetGame() {
    startGame();
    overlays.remove('gameOverOverlay');
  }

  void togglePauseState() {
    if (paused) {
      resumeEngine();
    } else {
      pauseEngine();
    }
  }

  void checkLevelUp() {
    if (levelManager.shouldLevelUp(gameManager.score.value)) {
      levelManager.increaseLevel();
    }
  }
}
