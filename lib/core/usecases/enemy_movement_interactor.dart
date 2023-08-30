import 'dart:math';

import 'package:flame/components.dart';
import 'package:shoot_em_up_stage_project/game/presentation/widgets/enemy_widget.dart';

class EnemyMovementInteractor extends Component {
  void move(double dt) {
    Enemy parentAsEnemy = parent as Enemy;

    parentAsEnemy.position.y += parentAsEnemy.entity.moveSpeed * dt;

    // if it's of screen
    if (parentAsEnemy.position.y > 640) {
      parentAsEnemy.position = Vector2(Random().nextDouble() * 360, 0);
    }
  }
}
