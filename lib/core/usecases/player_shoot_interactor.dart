import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/services.dart';
import 'package:shoot_em_up_stage_project/game/presentation/widgets/bullet_widget.dart';
import 'package:shoot_em_up_stage_project/game/presentation/widgets/player_widget.dart';

class PlayerShootInteractor extends Component with KeyboardHandler {
  bool hasPressedShoot = false;
  late double currentBulletWait;
  bool waitingForNextShot = false;

  void shoot(double dt) {
    Player parentAsPlayer = parent as Player;

    final fixedX = parentAsPlayer.scale.x < 0
        ? parentAsPlayer.position.x - parentAsPlayer.width
        : parentAsPlayer.position.x;

    // sets a small timer between being able to shoot
    if (!waitingForNextShot && hasPressedShoot) {
      // play shoot sound
      FlameAudio.play("Laser_Shoot4.wav", volume: 0.6);

      // spawn bullet
      Bullet newBullet = Bullet(
          moveSpeed: -parentAsPlayer.entity.bulletSpeed,
          position:
              Vector2(fixedX, parentAsPlayer.position.y) - Vector2(0, 32));
      parent?.parent?.add(newBullet); //(adds bullet to world)

      hasPressedShoot = false;
      waitingForNextShot = true;
      currentBulletWait = parentAsPlayer.entity.shootInterval;
    } else if (waitingForNextShot) {
      currentBulletWait -= 1 * dt;
      waitingForNextShot = !(currentBulletWait < 0);
    }
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    hasPressedShoot = keysPressed.contains(LogicalKeyboardKey.space);
    return super.onKeyEvent(event, keysPressed);
  }
}
