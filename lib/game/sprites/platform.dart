import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../doodle_dash.dart';

enum NormalPlatformState { only }

enum BrokenPlatformState { cracked, broken }

enum SpringState { up, down }

enum EnemyPlatformState { only }

abstract class Platform<T> extends SpriteGroupComponent<T>
    with HasGameRef<DoodleDash>, CollisionCallbacks {
  final hitbox = RectangleHitbox();
  bool isMoving = false;

  double direction = 1;
  final Vector2 _velocity = Vector2.zero();
  double speed = 35;

  Platform({
    super.position,
  }) : super(
          size: Vector2.all(100),
          priority: 2,
        );

  void _move(double dt) {
    if (!isMoving) return;

    final double gameWidth = gameRef.size.x;

    if (position.x <= 0) {
      direction = 1;
    } else if (position.x >= gameWidth - size.x) {
      direction = -1;
    }

    _velocity.x = direction * speed;
    position += _velocity * dt;
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    await add(hitbox);

    final int rand = Random().nextInt(100);
    if (rand > 80) isMoving = true;
  }

  @override
  void update(double dt) {
    _move(dt);
    super.update(dt);
  }
}

class NormalPlatform extends Platform<NormalPlatformState> {
  NormalPlatform({super.position});

  final Map<String, Vector2> spriteOptions = {
    'platform_monitor': Vector2(115, 84),
    'platform_phone_center': Vector2(100, 55),
    'platform_terminal': Vector2(110, 83),
    'platform_laptop': Vector2(100, 63),
  };

  @override
  Future<void>? onLoad() async {
    var randSpriteIndex = Random().nextInt(spriteOptions.length);

    String randSprite = spriteOptions.keys.elementAt(randSpriteIndex);

    sprites = {
      NormalPlatformState.only: await gameRef.loadSprite('game/$randSprite.png')
    };

    current = NormalPlatformState.only;

    size = spriteOptions[randSprite]!;
    await super.onLoad();
  }
}

class BrokenPlatform extends Platform<BrokenPlatformState> {
  BrokenPlatform({super.position});

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    sprites = <BrokenPlatformState, Sprite>{
      BrokenPlatformState.cracked:
          await gameRef.loadSprite('game/platform_cracked_monitor.png'),
      BrokenPlatformState.broken:
          await gameRef.loadSprite('game/platform_monitor_broken.png'),
    };

    current = BrokenPlatformState.cracked;
    size = Vector2(115, 84);
  }

  void breakPlatform() {
    current = BrokenPlatformState.broken;
  }
}

class SpringBoard extends Platform<SpringState> {
  SpringBoard({super.position});

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    sprites = <SpringState, Sprite>{
      SpringState.up:
          await gameRef.loadSprite('game/platform_trampoline_up.png'),
      SpringState.down:
          await gameRef.loadSprite('game/platform_trampoline_down.png'),
    };

    current = SpringState.up;
    size = Vector2(100, 45);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    bool isCollidingVertically =
        (intersectionPoints.first.y - intersectionPoints.last.y).abs() < 5;

    if (isCollidingVertically) {
      current = SpringState.down;
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);

    current = SpringState.up;
  }
}

class EmemyPlatform extends Platform<EnemyPlatformState> {
  EmemyPlatform({super.position});

  @override
  Future<void>? onLoad() async {
    var randBool = Random().nextBool();
    var enemySprite = randBool ? 'enemy_trash_can' : 'enemy_error';

    sprites = <EnemyPlatformState, Sprite>{
      EnemyPlatformState.only:
          await gameRef.loadSprite('game/$enemySprite.png'),
    };

    current = EnemyPlatformState.only;

    return super.onLoad();
  }
}
