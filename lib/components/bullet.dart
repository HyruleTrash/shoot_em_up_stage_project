import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:shoot_em_up_stage_project/components/enemy.dart';
import 'package:shoot_em_up_stage_project/components/world.dart';
import 'package:shoot_em_up_stage_project/shoot_em_up_stage_project.dart';

class Bullet extends PositionComponent with HasGameRef<ShootEmUpStageProject> {
  double moveSpeed;
  double damage;
  bool active = true;
  Bullet({this.moveSpeed = 20, this.damage = 1, position})
      : super(position: position);
  final SpriteComponent spriteComponent = SpriteComponent();

  @override
  Future<void> onLoad() async {
    //adds sprite
    spriteComponent.sprite = Sprite(game.images.fromCache('Bullet.png'));
    spriteComponent.size = Vector2(32, 32);
    add(spriteComponent);
    await super.onLoad();
  }

  @override
  void update(double dt) {
    if (active) {
      _checkCollisions();
      position.y += moveSpeed * dt;
      active = !(position.y < 0 || position.y + height > 640);
      super.update(dt);
    } else {
      spriteComponent.removeFromParent();
    }
  }

  void _checkCollisions() {
    for (var object in game.firstChild<GameWorld>()!.children) {
      if (object.runtimeType == Enemy) {
        Enemy enemy = object as Enemy;
        Vector2 magnitude = enemy.position - position;
        if (enemy.active == true &&
            sqrt(pow(magnitude.x, 2) + pow(magnitude.y, 2)) < 30) {
          spriteComponent.removeFromParent();
          enemy.hurt(damage);
          removeFromParent();
        }
      }
    }
  }
}
