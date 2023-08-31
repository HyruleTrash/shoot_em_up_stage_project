import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/services.dart';
import 'package:shoot_em_up_stage_project/game/presentation/game_world.dart';
import 'package:shoot_em_up_stage_project/game/presentation/bloc/game_event.dart';
import 'package:shoot_em_up_stage_project/game/presentation/bloc/game_state.dart';
import 'package:shoot_em_up_stage_project/game/presentation/enemy_spawner.dart';
import 'package:shoot_em_up_stage_project/game/presentation/widgets/bullet_widget.dart';
import 'package:shoot_em_up_stage_project/game/presentation/widgets/enemy_widget.dart';

class GameWorldInteract extends Component with KeyboardHandler {
  GameStatus oldState = GameStatus.playing;

  @override
  FutureOr<void> onLoad() {
    GameWorld parentAsGameWorld = parent as GameWorld;
    parentAsGameWorld.gameBloc.add(getHttp());
    return super.onLoad();
  }

  @override
  Future<void> update(double dt) async {
    GameWorld parentAsGameWorld = parent as GameWorld;
    final GameState gameState = parentAsGameWorld.gameBloc.state;

    if (gameState.status != GameStatus.playing) {
      if (oldState == GameStatus.playing) {
        parentAsGameWorld.player.healthInteractor.stopPlayer();
        parentAsGameWorld.firstChild<EnemySpawner>()?.active = false;
        if (gameState.status == GameStatus.lost) {
          parentAsGameWorld.player.healthInteractor.death();
        }
      }
      oldState = gameState.status;
    }

    statusSwitch:
    switch (gameState.status) {
      case GameStatus.playing:
        //sets point counter
        parentAsGameWorld.playerPointsUI.text = "points: ${gameState.points}";
        //sets hp counter
        parentAsGameWorld.playerHealthUI.text = "HP: ${gameState.hp}";
        //sets chuck's UI
        parentAsGameWorld.chuckUI.text = gameState.httpResult ?? "";
        // end game when you get 100 points
        if (gameState.points >= 100) {
          parentAsGameWorld.gameBloc.add(setStatusWon());
          break statusSwitch;
        }
        // end game if hp is to low
        if (gameState.hp <= 0) {
          parentAsGameWorld.gameBloc.add(setStatusLost());
          break statusSwitch;
        }
        break;
      case GameStatus.won:
        parentAsGameWorld.endGameMessage.text = "You win! (press space)";
        break;
      case GameStatus.lost:
        parentAsGameWorld.endGameMessage.text = "You Lose (press Space)";
        break;
    }
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    GameWorld parentAsGameWorld = parent as GameWorld;
    if (parentAsGameWorld.gameBloc.state.status != GameStatus.playing &&
        keysPressed.contains(LogicalKeyboardKey.space)) {
      restartGame();
    }
    return super.onKeyEvent(event, keysPressed);
  }

  void restartGame() async {
    GameWorld parentAsGameWorld = parent as GameWorld;

    // ignore: invalid_use_of_internal_member
    parentAsGameWorld.children.removeWhere((child) {
      if (child is Enemy) {
        child.entity.hitBox.removeFromParent();
        return true;
      }
      return false;
    });
    // ignore: invalid_use_of_internal_member
    parentAsGameWorld.children.removeWhere((child) => child is Bullet);

    // re setup Player
    parentAsGameWorld.player.active = true;
    parentAsGameWorld.gameBloc.add(resetHP());
    parentAsGameWorld.gameBloc.add(resetPoints());

    parentAsGameWorld.player.position.y =
        640 - 32 * 2; // bottom of the screen minos the player size twice
    parentAsGameWorld.player
        .add(OpacityEffect.to(1.0, EffectController(duration: 0.001)));
    parentAsGameWorld.player.update(1);

    // re start spawner
    parentAsGameWorld.enemySpawner.active = true;
    parentAsGameWorld.enemySpawner.update(1);

    // clear end game message
    parentAsGameWorld.endGameMessage.text = "";

    // set to playing
    parentAsGameWorld.gameBloc.add(setStatusPlaying());
    oldState = GameStatus.playing;
  }
}
