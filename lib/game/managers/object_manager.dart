import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter_paralax_game/game/managers/level_manager.dart';

import '../doodle_dash.dart';
import '../util/num_utils.dart';
import '../sprites/platform.dart';

final Random _rand = Random();

class ObjectManager extends Component with HasGameRef<DoodleDash> {
  ObjectManager({
    this.minVerticalDistanceToNextPlatform = 200,
    this.maxVerticalDistanceToNextPlatform = 300,
  });

  double minVerticalDistanceToNextPlatform;
  double maxVerticalDistanceToNextPlatform;

  final probGen =
      ProbabilityGenerator(); // comes from the util/num_utils.dart file
  final double _tallestPlatformHeight = 50;
  final List<Platform> _platforms =
      []; // need to write the platform.dart file for sprites

  final Map<String, bool> specialPlatforms = {
    'spring': true,
    'broken': false,
    'noogle': false,
    'rocket': false,
    'enemy': false,
  };

  void _cleanupPlatforms() {
    final lowestPlat = _platforms.removeAt(0);

    lowestPlat.removeFromParent();
  }

  void enableSpecialty(String specialty) {
    specialPlatforms[specialty] = true;
  }

  void enableLevelSpecialty(int level) {}

  void resetSpecialties() {
    for (var key in specialPlatforms.keys) {
      specialPlatforms[key] = false;
    }
  }

  void configure(int nextLevel, Difficulty config) {
    minVerticalDistanceToNextPlatform = gameRef.levelManager.minDistance;
    maxVerticalDistanceToNextPlatform = gameRef.levelManager.maxDistance;

    for (int i = 1; i <= nextLevel; i++) {
      enableLevelSpecialty(i);
    }
  }

  double _generateNextX(int platformWidth) {
    final previousPlatformXRange = Range(
      _platforms.last.position.x,
      _platforms.last.position.x + platformWidth,
    );

    double nextPlatformAnchorX;

    do {
      nextPlatformAnchorX =
          _rand.nextInt(gameRef.size.x.floor() - platformWidth).toDouble();
    } while (previousPlatformXRange.overlaps(
        Range(nextPlatformAnchorX, nextPlatformAnchorX + platformWidth)));
    return nextPlatformAnchorX;
  }

  double _generateNextY() {
    final currentHightestPlatformY =
        _platforms.last.center.y + _tallestPlatformHeight;

    final distanceToNextY = minVerticalDistanceToNextPlatform.toInt() +
        _rand
            .nextInt((maxVerticalDistanceToNextPlatform -
                    minVerticalDistanceToNextPlatform)
                .floor())
            .toDouble();

    return currentHightestPlatformY - distanceToNextY;
  }
}
