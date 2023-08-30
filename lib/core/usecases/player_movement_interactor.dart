import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:shoot_em_up_stage_project/game/presentation/widgets/player_widget.dart';

class PlayerMovementInteractor extends Component with KeyboardHandler {
  final List walls = [-10, 360];

  double horizontalMovement = 0;
  Vector2 velocity = Vector2.zero();

  @override
  FutureOr<void> onLoad() {
    Player parentAsPlayer = parent as Player;
    // add hitbox
    parent?.add(parentAsPlayer.entity.hitBox);
    return super.onLoad();
  }

  void move(dt) {
    Player parentAsPlayer = parent as Player;
    // Left and Right movement
    velocity.x = horizontalMovement * parentAsPlayer.entity.moveSpeed;
    parentAsPlayer.position.x += velocity.x * dt;
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    final isKeyLeftPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isKeyRightPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    horizontalMovement += isKeyLeftPressed ? -1 : 0;
    horizontalMovement += isKeyRightPressed ? 1 : 0;

    return super.onKeyEvent(event, keysPressed);
  }

  void checkWallCollision() {
    Player parentAsPlayer = parent as Player;
    final fixedX = parentAsPlayer.scale.x < 0
        ? parentAsPlayer.position.x - parentAsPlayer.width
        : parentAsPlayer.position.x;
    for (var wallX in walls) {
      if (fixedX < wallX + 10 && fixedX + parentAsPlayer.width > wallX) {
        if (velocity.x > 0) {
          velocity.x = 0;
          parentAsPlayer.position.x = wallX - parentAsPlayer.width;
          break;
        }
        if (velocity.x < 0) {
          velocity.x = 0;
          parentAsPlayer.position.x = wallX + 10 + parentAsPlayer.width;
          break;
        }
      }
    }
  }
}
