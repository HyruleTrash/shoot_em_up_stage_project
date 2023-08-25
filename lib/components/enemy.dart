import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/geometry.dart';
import 'package:flame/rendering.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:shoot_em_up_stage_project/components/world.dart';
import 'package:shoot_em_up_stage_project/shoot_em_up_stage_project.dart';

class Enemy extends PositionComponent with HasGameRef<ShootEmUpStageProject> {
  double moveSpeed = 50;
  double damageTaken = 0;
  double maxDamage = 3;
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

    // add hue shift
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

    await super.onLoad();
  }

  @override
  void update(double dt) {
    if (active) {
      //movement
      position.y += moveSpeed * dt;

      // if it's of screen
      if (position.y > 640) {
        position = Vector2(Random().nextDouble() * 360, 0);
      }
      super.update(dt);
    }
  }

  void hurt(double damage) {
    damageTaken += damage;
    Color enemyColor = Color.fromRGBO(
        (155.0 - (100 / damageTaken == 0 ? 0.1 : damageTaken)).toInt(),
        0,
        0,
        0.667);

    //hurt noise
    FlameAudio.play("Hit_Hurt2.wav", volume: 0.6);

    //hue shift update
    spriteComponent.decorator.addLast(PaintDecorator.tint(enemyColor));
    if (damageTaken >= maxDamage) {
      active = false;
      //death noise
      FlameAudio.play("Explosion3.wav", volume: 0.6);

      GameWorld? parentWorld = parent as GameWorld?;
      parentWorld?.points++;
      spriteComponent.removeFromParent();
    }
  }
}
