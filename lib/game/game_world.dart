import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/painting.dart';
import 'package:shoot_em_up_stage_project/game/domain/usecases/game_world_interact.dart';
import 'package:shoot_em_up_stage_project/game/presentation/enemy_spawner.dart';
import 'package:shoot_em_up_stage_project/game/presentation/widgets/player_widget.dart';

class GameWorld extends World {
  final Player player;
  EnemySpawner enemySpawner = EnemySpawner();
  GameWorld({required this.player});

  final GameWorldInteract interact = GameWorldInteract();

  final TextComponent playerHealthUI = TextComponent();
  final TextComponent playerPointsUI = TextComponent();
  final TextComponent endGameMessage = TextComponent();

  int points = 0;

  @override
  FutureOr<void> onLoad() {
    // setup Player
    player.position = Vector2(
        180, 640 - 32 * 2); // bottom of the screen minus the player size twice
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

    //set up interactor(s)
    add(interact);

    // start background music
    FlameAudio.loop("8bit_adventure_david_renda.mp3", volume: 0.4);
  }
}
