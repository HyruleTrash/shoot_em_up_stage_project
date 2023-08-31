import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/rendering.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:shoot_em_up_stage_project/game/presentation/bloc/game_event.dart';
import 'package:shoot_em_up_stage_project/game/presentation/widgets/enemy_widget.dart';
import 'package:shoot_em_up_stage_project/game/presentation/game_world.dart';

class EnemyHealthInteractor extends Component {
  void hurt(double damage) {
    Enemy parentAsEnemy = parent as Enemy;
    parentAsEnemy.entity.damageTaken += damage;
    Color enemyColor = Color.fromRGBO(
        (155.0 -
                (100 / parentAsEnemy.entity.damageTaken == 0
                    ? 0.1
                    : parentAsEnemy.entity.damageTaken))
            .toInt(),
        0,
        0,
        0.667);

    //hurt noise
    FlameAudio.play("Hit_Hurt2.wav", volume: 0.6);

    //hue shift update
    parentAsEnemy.spriteComponent.decorator
        .addLast(PaintDecorator.tint(enemyColor));
    if (parentAsEnemy.entity.damageTaken >= parentAsEnemy.entity.maxDamage) {
      parentAsEnemy.active = false;
      //death noise
      FlameAudio.play("Explosion3.wav", volume: 0.6);

      GameWorld? parentWorld = parent?.parent as GameWorld?;
      parentWorld?.gameBloc.add(addPoint());
      parentAsEnemy.spriteComponent.removeFromParent();
      parentAsEnemy.entity.hitBox.collisionType = CollisionType.inactive;
    }
  }
}
