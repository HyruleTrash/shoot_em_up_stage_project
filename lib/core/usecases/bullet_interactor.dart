import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:shoot_em_up_stage_project/game/presentation/widgets/bullet_widget.dart';

class BulletInteractor extends Component {
  @override
  FutureOr<void> onLoad() {
    parent?.add(RectangleHitbox(
        size: Vector2(7, 32),
        position: Vector2(16, 16),
        anchor: Anchor.center));
    return super.onLoad();
  }

  void move(dt) {
    Bullet parentAsBullet = parent as Bullet;
    //space transformation (movement)
    Matrix2 bulletTransform = Matrix2(
        parentAsBullet.position.x,
        parentAsBullet.scale.x,
        parentAsBullet.position.y,
        parentAsBullet.scale.y);
    Matrix2 moveByMatrix =
        Matrix2(0, 0, parentAsBullet.entity.moveSpeed * dt, 0);
    bulletTransform += moveByMatrix;

    //set matrix back to component values
    parentAsBullet.position = bulletTransform.row0;
    parentAsBullet.scale = bulletTransform.row1;

    //check if off screen
    parentAsBullet.active = !(parentAsBullet.position.y < 0 ||
        parentAsBullet.position.y + parentAsBullet.height > 640);
  }
}
