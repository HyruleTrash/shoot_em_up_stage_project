import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
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
    add(RectangleHitbox(
        size: Vector2(7, 32),
        position: Vector2(16, 16),
        anchor: Anchor.center));
    await super.onLoad();
  }

  @override
  void update(double dt) {
    if (active) {
      //space transformation (movement)
      Matrix2 bulletTransform =
          Matrix2(position.x, scale.x, position.y, scale.y);
      Matrix2 moveByMatrix = Matrix2(0, 0, moveSpeed * dt, 0);
      bulletTransform += moveByMatrix;

      //set matrix back to component values
      position = bulletTransform.row0;
      scale = bulletTransform.row1;

      active = !(position.y < 0 || position.y + height > 640);
      super.update(dt);
    } else {
      spriteComponent.removeFromParent();
    }
  }
}
