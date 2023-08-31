import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:shoot_em_up_stage_project/game/presentation/bloc/game_event.dart';
import 'package:shoot_em_up_stage_project/game/presentation/explosion_particle.dart';
import 'package:shoot_em_up_stage_project/game/presentation/widgets/player_widget.dart';
import 'package:shoot_em_up_stage_project/game/presentation/game_world.dart';
import 'package:shoot_em_up_stage_project/shoot_em_up_stage_project.dart';

class PlayerHealthInteractor extends Component
    with HasGameRef<ShootEmUpStageProject> {
  void hurt() {
    Player parentAsPlayer = parent as Player;
    // damage
    parentAsPlayer.game.firstChild<GameWorld>()?.gameBloc.add(lessenHP());

    // damage flinch
    parent?.add(ColorEffect(
      Color.fromARGB(255, 255, 255, 255),
      const Offset(0.0, 0.8),
      EffectController(duration: 0.1, reverseDuration: 0.1),
    ));

    //hurt noise
    FlameAudio.play("Hit_Hurt.wav", volume: 0.6);
  }

  void death() {
    Player parentAsPlayer = parent as Player;
    final fixedX = parentAsPlayer.scale.x < 0
        ? parentAsPlayer.width / 2
        : -parentAsPlayer.width / 2;
    parent?.add(ExplosionParticle(Vector2(fixedX, 0)));

    //death noise
    FlameAudio.play("Explosion4.wav", volume: 0.6);
  }

  void stopPlayer() {
    Player parentAsPlayer = parent as Player;
    parentAsPlayer.active = false;
    parent?.add(OpacityEffect.to(0.0, EffectController(duration: 0.001)));
  }
}
