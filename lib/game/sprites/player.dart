import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paralax_game/game/sprites/platform.dart';

import '../doodle_dash.dart';
import '../managers/game_manager.dart';

enum PlayerState {
  left,
  right,
  center,
  rocket,
  nooglerCenter,
  noogleLeft,
  nooglerRight,
}

class Player extends SpriteGroupComponent<PlayerState>
    with HasGameRef<DoodleDash>, KeyboardHandler, CollisionCallbacks {
  Player({
    super.position,
    required this.character,
    this.jumpSpeed = 600,
  }) : super(
          size: Vector2(79, 109),
          anchor: Anchor.center,
          priority: 1,
        );

  int _hAxisInput = 0;
  final int movingLeftInput = -1;
  final int movingRightInput = 1;
  Vector2 _velocity = Vector2.zero();
  bool get isMovingDown => _velocity.y > 0;
  Character character;
  double jumpSpeed;
  final _gravity = 9;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await add(CircleHitbox());

    await _loadCharacterSprites();
    current = PlayerState.center;
  }

  @override
  void update(double dt) {
    if (gameRef.gameManager.isIntro || gameRef.gameManager.isGameOver) return;

    _velocity.x = _hAxisInput * jumpSpeed;

    final double dashHorizontalCenter = size.x / 2;

    if (position.x < dashHorizontalCenter) {
      position.x = gameRef.size.x - (dashHorizontalCenter);
    }
    if (position.x > gameRef.size.x - (dashHorizontalCenter)) {
      position.x = dashHorizontalCenter;
    }

    _velocity.y += _gravity;

    position += _velocity * dt;

    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _hAxisInput = 0;

    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      moveLeft();
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      moveRight();
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      // make player go up
    }
    return true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    bool isCollidingVertically =
        (intersectionPoints.first.y - intersectionPoints.last.y).abs() < 5;

    if (isMovingDown && isCollidingVertically) {
      current = PlayerState.center;
      if (other is NormalPlatform) {
        jump();
        return;
      } else if (other is SpringBoard) {
        jump(specialJumpSpeed: jumpSpeed * 2);
        return;
      } else if (other is BrokenPlatform &&
          other.current == BrokenPlatformState.cracked) {
        jump();
        other.breakPlatform();
        return;
      }
    }
  }

  void moveLeft() {
    _hAxisInput = 0;
    current = PlayerState.left;
    _hAxisInput += movingLeftInput;
  }

  void moveRight() {
    _hAxisInput = 0;
    current = PlayerState.right;
    _hAxisInput += movingRightInput;
  }

  void reesetDirection() {
    _hAxisInput = 0;
  }

  void jump({double? specialJumpSpeed}) {
    _velocity.y = specialJumpSpeed != null ? -specialJumpSpeed : -jumpSpeed;
  }

  void _removePowerupAfterTime(int ms) {
    Future.delayed(Duration(microseconds: ms), () {
      current = PlayerState.center;
    });
  }

  void setJumpSpeed(double newJumpSpeed) {
    jumpSpeed = newJumpSpeed;
  }

  void reset() {
    _velocity = Vector2.zero();
    current = PlayerState.center;
  }

  void resetPosition() {
    position = Vector2(
      (gameRef.size.x - size.x) / 2,
      (gameRef.size.y - size.y) / 2,
    );
  }

  Future<void> _loadCharacterSprites() async {
    final left = await gameRef.loadSprite('game/${character.name}_left.png');
    final right = await gameRef.loadSprite('game/${character.name}_right.png');
    final center =
        await gameRef.loadSprite('game/${character.name}_center.png');
    final rocket = await gameRef.loadSprite('game/rocket_4.png');
    final nooglerCenter =
        await gameRef.loadSprite('game/${character.name}_hat_center.png');
    final nooglerLeft =
        await gameRef.loadSprite('game/${character.name}_hat_left.png');
    final nooglerRight =
        await gameRef.loadSprite('game/${character.name}_hat_right.png');

    sprites = <PlayerState, Sprite>{
      PlayerState.left: left,
      PlayerState.right: right,
      PlayerState.center: center,
      PlayerState.rocket: rocket,
      PlayerState.nooglerCenter: nooglerCenter,
      PlayerState.noogleLeft: nooglerLeft,
      PlayerState.nooglerRight: nooglerRight,
    };
  }
}
