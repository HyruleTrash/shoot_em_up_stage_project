import 'dart:async';

import 'package:flame/components.dart';
import 'package:shoot_em_up_stage_project/core/entities/bullet_entity.dart';
import 'package:shoot_em_up_stage_project/core/usecases/bullet_interactor.dart';
import 'package:shoot_em_up_stage_project/shoot_em_up_stage_project.dart';

class Bullet extends PositionComponent with HasGameRef<ShootEmUpStageProject> {
  BulletEntity entity = BulletEntity();
  BulletInteractor interactor = BulletInteractor();
  double moveSpeed;
  double damage;

  bool active = true;

  Bullet({this.moveSpeed = 20, this.damage = 1, position})
      : super(position: position);

  final SpriteComponent spriteComponent = SpriteComponent();

  @override
  Future<void> onLoad() async {
    //set entity values
    entity.moveSpeed = moveSpeed;
    entity.damage = damage;

    //adds sprite
    spriteComponent.sprite = Sprite(game.images.fromCache('Bullet.png'));
    spriteComponent.size = Vector2(32, 32);
    add(spriteComponent);

    //adds entity
    add(entity);

    //adds Interactor(s)
    add(interactor);

    await super.onLoad();
  }

  @override
  void update(double dt) {
    if (active) {
      interactor.move(dt);
      super.update(dt);
    } else {
      spriteComponent.removeFromParent();
    }
  }
}
