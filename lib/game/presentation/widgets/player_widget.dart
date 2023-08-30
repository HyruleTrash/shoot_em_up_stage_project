import 'dart:async';

import 'package:flame/components.dart';
import 'package:shoot_em_up_stage_project/core/entities/player_entity.dart';
import 'package:shoot_em_up_stage_project/core/usecases/player_health_interactor.dart';
import 'package:shoot_em_up_stage_project/core/usecases/player_movement_interactor.dart';
import 'package:shoot_em_up_stage_project/core/usecases/player_shoot_interactor.dart';
import 'package:shoot_em_up_stage_project/game/game_world.dart';
import 'package:shoot_em_up_stage_project/shoot_em_up_stage_project.dart';

enum PlayerState { idle, moving }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<ShootEmUpStageProject> {
  Player({position}) : super(position: position);

  PlayerEntity entity = PlayerEntity();
  PlayerMovementInteractor movementInteractor = PlayerMovementInteractor();
  PlayerShootInteractor shootInteractor = PlayerShootInteractor();
  PlayerHealthInteractor healthInteractor = PlayerHealthInteractor();

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation movingAnimation;
  final double stepTime = 0.05;

  bool active = true;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();

    //update health UI
    game
        .firstChild<GameWorld>()
        ?.interact
        .setHealthUI(entity.health.toString());

    //adds entity
    add(entity);

    //adds Interactor(s)
    add(movementInteractor);
    add(shootInteractor);
    add(healthInteractor);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (active) {
      _updatePlayerState();

      // shoot check
      shootInteractor.shoot(dt);

      // movement
      movementInteractor.move(dt);
      movementInteractor.checkWallCollision();

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

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if (movementInteractor.velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (movementInteractor.velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    // check if moving set running
    if (movementInteractor.velocity.x < 0 ||
        movementInteractor.velocity.x > 0) {
      playerState = PlayerState.moving;
    }

    current = playerState;
  }
}
