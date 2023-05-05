import 'package:flame/components.dart';
import '../doodle_dash.dart';

class Difficulty {
  final double minDisatnce;
  final double maxDistance;
  final double jumpSpeed;
  final int score;

  const Difficulty({
    required this.minDisatnce,
    required this.maxDistance,
    required this.jumpSpeed,
    required this.score,
  });
}

class LevelManager extends Component with HasGameRef<DoodleDash> {
  LevelManager({this.selectedLevel = 1, this.level = 1});

  int selectedLevel;
  int level;

  final Map<int, Difficulty> levelConfig = {
    1: const Difficulty(
        minDisatnce: 200, maxDistance: 300, jumpSpeed: 600, score: 0),
    2: const Difficulty(
        minDisatnce: 200, maxDistance: 400, jumpSpeed: 650, score: 20),
    3: const Difficulty(
        minDisatnce: 200, maxDistance: 500, jumpSpeed: 700, score: 40),
    4: const Difficulty(
        minDisatnce: 200, maxDistance: 600, jumpSpeed: 750, score: 80),
    5: const Difficulty(
        minDisatnce: 200, maxDistance: 700, jumpSpeed: 800, score: 100),
  };

  double get minDistance {
    return levelConfig[level]!.minDisatnce;
  }

  double get maxDistance {
    return levelConfig[level]!.maxDistance;
  }

  double get startingJumpSpeed {
    return levelConfig[level]!.jumpSpeed;
  }

  double get jumpSpeed {
    return levelConfig[level]!.jumpSpeed;
  }

  Difficulty get difficulty {
    return levelConfig[level]!;
  }

  bool shouldLevelUp(int score) {
    int nextLevel = level + 1;

    if (levelConfig.containsKey(nextLevel))
      return levelConfig[nextLevel]!.score == score;

    return false;
  }

  List<int> get levels {
    return levelConfig.keys.toList();
  }

  void increaseLevel() {
    if (level < levelConfig.keys.length) level++;
  }

  void setLevel(int newLevel) {
    print('new level: ${newLevel}');
    if (levelConfig.containsKey(newLevel)) level = newLevel;
  }

  void selectLevel(int selectLevel) {
    if (levelConfig.containsKey(selectLevel)) selectedLevel = selectLevel;
  }

  void reset() {
    level = selectedLevel;
  }
}
