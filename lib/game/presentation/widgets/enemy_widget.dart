import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/geometry.dart';
import 'package:flame/rendering.dart';
import 'package:flutter/material.dart';
import 'package:shoot_em_up_stage_project/core/entities/enemy_entity.dart';
import 'package:shoot_em_up_stage_project/core/usecases/enemy_collision_detection_interactor.dart';
import 'package:shoot_em_up_stage_project/core/usecases/enemy_health_interactor.dart';
import 'package:shoot_em_up_stage_project/core/usecases/enemy_movement_interactor.dart';
import 'package:shoot_em_up_stage_project/shoot_em_up_stage_project.dart';

class Enemy extends PositionComponent with HasGameRef<ShootEmUpStageProject> {
  EnemyEntity entity = EnemyEntity();
  EnemyMovementInteractor movementInteractor = EnemyMovementInteractor();
  EnemyCollisionDetectorInteractor collisionDetectorInteractor =
      EnemyCollisionDetectorInteractor();
  EnemyHealthInteractor healthInteractor = EnemyHealthInteractor();

  bool active = true;

  Enemy({position}) : super(position: position);
  final SpriteComponent spriteComponent = SpriteComponent();

  @override
  Future<void> onLoad() async {
    //adds sprite
    spriteComponent.sprite =
        Sprite(game.images.fromCache('SpaceShipEnemy.png'));
    spriteComponent.size = Vector2(32, 32);
    spriteComponent.anchor = Anchor.center;
    add(spriteComponent);

    //add hue shift
    spriteComponent.decorator
        .addLast(PaintDecorator.tint(Color.fromRGBO(155, 0, 0, 0.667)));

    //spinning effect
    spriteComponent.add(RotateEffect.to(
      tau * Random().nextDouble() * 2.5,
      EffectController(duration: 0.0000001, infinite: true),
    ));
    spriteComponent.add(RotateEffect.by(
      pi * 2,
      EffectController(
          duration: Random().nextDouble() * 2.5 + 1, infinite: true),
    ));

    //adds entity
    add(entity);

    //adds Interactor(s)
    add(movementInteractor);
    add(collisionDetectorInteractor);
    add(healthInteractor);

    await super.onLoad();
  }

  @override
  void update(double dt) {
    if (active) {
      //movement
      movementInteractor.move(dt);
      super.update(dt);
    }
  }
}
