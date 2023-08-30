import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/palette.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/painting.dart';
import 'package:shoot_em_up_stage_project/components/bullet.dart';
import 'package:shoot_em_up_stage_project/components/enemy.dart';
import 'package:shoot_em_up_stage_project/components/enemy_spawner.dart';
import 'package:shoot_em_up_stage_project/components/player.dart';

class GameWorld extends World {
  final Player player;
  EnemySpawner enemySpawner = EnemySpawner();
  GameWorld({required this.player});

  final TextComponent playerHealthUI = TextComponent();
  final TextComponent playerPointsUI = TextComponent();
  final TextComponent endGameMessage = TextComponent();

  int points = 0;

  @override
  FutureOr<void> onLoad() {
    // setup Player
    player.position = Vector2(
        180, 640 - 32 * 2); // bottom of the screen minos the player size twice
    add(player);

    // enemy spawner
    add(enemySpawner);

    // setup health UI
    playerHealthUI.textRenderer =
        TextPaint(style: TextStyle(color: BasicPalette.white.color));
    playerHealthUI.anchor = Anchor.bottomCenter;
    playerHealthUI.position = Vector2(180, 630);
    add(playerHealthUI);

    // setup points UI
    playerPointsUI.textRenderer = TextPaint(
        style: TextStyle(color: BasicPalette.white.color, fontSize: 20));
    playerPointsUI.anchor = Anchor.bottomCenter;
    playerPointsUI.position = Vector2(180, 32);
    add(playerPointsUI);

    // setup message for end of the game
    endGameMessage.textRenderer = TextPaint(
        style: TextStyle(color: BasicPalette.white.color, fontSize: 32));
    endGameMessage.anchor = Anchor.bottomCenter;
    endGameMessage.position = Vector2(180, 320);
    add(endGameMessage);

    // start background music
    FlameAudio.loop("8bit_adventure_david_renda.mp3", volume: 0.4);
  }

  @override
  void update(double dt) {
    playerPointsUI.text = "points: $points";
    if (points >= 100) {
      player.stopPlayer();
      endGameMessage.text = "You win! (press space)";
    }
    super.update(dt);
  }

  void restartGame() async {
    // ignore: invalid_use_of_internal_member
    children.removeWhere((child) {
      if (child is Enemy) {
        child.hitBox.removeFromParent();
        return true;
      }
      return false;
    });
    // ignore: invalid_use_of_internal_member
    children.removeWhere((child) => child is Bullet);

    points = 0;

    // re setup Player
    player.active = true;
    player.health = 3;
    playerHealthUI.text = "HP: ${player.health}";
    player.position.y =
        640 - 32 * 2; // bottom of the screen minos the player size twice
    player.add(OpacityEffect.to(1.0, EffectController(duration: 0.001)));
    player.update(1);

    // re start spawner
    enemySpawner.active = true;
    enemySpawner.update(1);

    // clear end game message
    endGameMessage.text = "";
  }
}
