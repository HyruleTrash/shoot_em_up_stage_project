import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:shoot_em_up_stage_project/game/presentation/widgets/bullet_widget.dart';
import 'package:shoot_em_up_stage_project/game/presentation/widgets/enemy_widget.dart';
import 'package:shoot_em_up_stage_project/game/presentation/widgets/player_widget.dart';

class EnemyCollisionDetectorInteractor extends PositionComponent
    with CollisionCallbacks {
  @override
  FutureOr<void> onLoad() {
    Enemy parentAsEnemy = parent as Enemy;
    add(parentAsEnemy.entity.hitBox);
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    Enemy parentAsEnemy = parent as Enemy;
    if (parentAsEnemy.active) {
      if (other is Bullet) {
        parentAsEnemy.healthInteractor.hurt(other.damage);
        other.removeFromParent();
      } else if (other is Player && other.active) {
        other.healthInteractor.hurt();
        parentAsEnemy.entity.damageTaken = parentAsEnemy.entity.maxDamage;
        parentAsEnemy.healthInteractor.hurt(0);
      }
    }
    super.onCollision(intersectionPoints, other);
  }
}
