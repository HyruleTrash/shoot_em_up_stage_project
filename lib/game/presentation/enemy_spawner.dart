import 'dart:math';

import 'package:flame/components.dart';
import 'package:shoot_em_up_stage_project/game/presentation/widgets/enemy_widget.dart';

class EnemySpawner extends Component {
  double timeSpentWaiting = 0;
  double maxWaitTime = 1;
  bool active = true;

  @override
  void update(double dt) {
    if (active) {
      timeSpentWaiting += dt;
      if (timeSpentWaiting > maxWaitTime) {
        timeSpentWaiting = 0;
        // spawn enemy
        parent?.add(Enemy(position: Vector2(Random().nextDouble() * 360, 0)));
      }
      super.update(dt);
    }
  }
}
