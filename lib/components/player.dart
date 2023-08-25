import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:shoot_em_up_stage_project/components/bullet.dart';
import 'package:shoot_em_up_stage_project/components/enemy.dart';
import 'package:shoot_em_up_stage_project/components/enemy_spawner.dart';
import 'package:shoot_em_up_stage_project/components/explosion_particle.dart';
import 'package:shoot_em_up_stage_project/components/world.dart';
import 'package:shoot_em_up_stage_project/shoot_em_up_stage_project.dart';
import 'package:flutter/services.dart';

enum PlayerState { idle, moving }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<ShootEmUpStageProject>, KeyboardHandler {
  Player({position}) : super(position: position);

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation movingAnimation;
  final double stepTime = 0.05;

  final List walls = [-10, 360];

  double horizontalMovement = 0;
  double moveSpeed = 200;
  Vector2 velocity = Vector2.zero();

  bool hasPressedShoot = false;
  double shootInterval = 0.2;
  late double currentBulletWait;
  bool waitingForNextShot = false;
  double bulletSpeed = 350;

  int health = 3;
  bool active = true;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();

    // set health ui
    _setHealthUi();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (active) {
      _updatePlayerState();

      _shoot(dt);

      // Left and Right movement
      velocity.x = horizontalMovement * moveSpeed;
      position.x += velocity.x * dt;

      _checkWallCollision();
      _checkCollisions();

      super.update(dt);
    }
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('Idle', 6);
    movingAnimation = _spriteAnimation('Moving', 6);

    // List of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.moving: movingAnimation
    };

    // set current animation
    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('SpaceShip $state.png'),
        SpriteAnimationData.sequenced(
            amount: amount, stepTime: stepTime, textureSize: Vector2.all(32)));
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    final isKeyLeftPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isKeyRightPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    horizontalMovement += isKeyLeftPressed ? -1 : 0;
    horizontalMovement += isKeyRightPressed ? 1 : 0;

    hasPressedShoot = keysPressed.contains(LogicalKeyboardKey.space);

    // if the player is dead, spacebar becomes restart
    if (!active && hasPressedShoot) {
      GameWorld? parentWorld = parent as GameWorld?;
      parentWorld?.restartGame();
    }

    return super.onKeyEvent(event, keysPressed);
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    // check if moving set running
    if (velocity.x < 0 || velocity.x > 0) {
      playerState = PlayerState.moving;
    }

    current = playerState;
  }

  void _checkWallCollision() {
    final fixedX = scale.x < 0 ? position.x - width : position.x;
    for (var wallX in walls) {
      if (fixedX < wallX + 10 && fixedX + width > wallX) {
        if (velocity.x > 0) {
          velocity.x = 0;
          position.x = wallX - width;
          break;
        }
        if (velocity.x < 0) {
          velocity.x = 0;
          position.x = wallX + 10 + width;
          break;
        }
      }
    }
  }

  void _shoot(double dt) {
    final fixedX = scale.x < 0 ? position.x - width : position.x;
    // sets a small timer between being able to shoot
    if (!waitingForNextShot && hasPressedShoot) {
      FlameAudio.play("Laser_Shoot4.wav", volume: 0.6);
      Bullet newBullet = Bullet(
          moveSpeed: -bulletSpeed,
          position: Vector2(fixedX, position.y) - Vector2(0, 32));
      parent?.add(newBullet);
      hasPressedShoot = false;
      waitingForNextShot = true;
      currentBulletWait = shootInterval;
    } else if (waitingForNextShot) {
      currentBulletWait -= 1 * dt;
      waitingForNextShot = !(currentBulletWait < 0);
    }
  }

  void _checkCollisions() {
    for (var object in game.firstChild<GameWorld>()!.children) {
      if (object.runtimeType == Enemy) {
        Enemy enemy = object as Enemy;
        Vector2 magnitude = enemy.position - position;
        if (enemy.active == true &&
            sqrt(pow(magnitude.x, 2) + pow(magnitude.y, 2)) < 30) {
          // damage
          health--;
          enemy.damageTaken = enemy.maxDamage;
          enemy.hurt(1);

          // damage flinch
          add(ColorEffect(
            Color.fromARGB(255, 255, 255, 255),
            const Offset(0.0, 0.8),
            EffectController(duration: 0.1, reverseDuration: 0.1),
          ));

          // update health Ui
          _setHealthUi();

          //hurt noise
          FlameAudio.play("Hit_Hurt.wav", volume: 0.6);

          //Lose
          if (health <= 0) {
            final fixedX = scale.x < 0 ? width / 2 : -width / 2;
            add(ExplosionParticle(Vector2(fixedX, 0)));

            //death noise
            FlameAudio.play("Explosion4.wav", volume: 0.6);

            stopPlayer();
            GameWorld? parentWorld = parent as GameWorld?;
            parentWorld?.endGameMessage.text = "You Lose (press Space)";
          }
        }
      }
    }
  }

  void stopPlayer() {
    active = false;
    add(OpacityEffect.to(0.0, EffectController(duration: 0.001)));
    GameWorld? parentWorld = parent as GameWorld?;
    parentWorld?.firstChild<EnemySpawner>()?.active = false;
  }

  void _setHealthUi() {
    GameWorld? parentWorld = parent as GameWorld?;
    parentWorld?.playerHealthUI.text = "HP: $health";
  }
}
