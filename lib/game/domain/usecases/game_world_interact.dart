import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:shoot_em_up_stage_project/game/game_world.dart';
import 'package:shoot_em_up_stage_project/game/presentation/widgets/bullet_widget.dart';
import 'package:shoot_em_up_stage_project/game/presentation/widgets/enemy_widget.dart';

class GameWorldInteract extends Component {
  @override
  void update(double dt) {
    GameWorld parentAsGameWorld = parent as GameWorld;

    //sets point counter
    parentAsGameWorld.playerPointsUI.text =
        "points: ${parentAsGameWorld.points}";

    // end game when you get 100 points
    if (parentAsGameWorld.points >= 100) {
      parentAsGameWorld.player.healthInteractor.stopPlayer();
      parentAsGameWorld.endGameMessage.text = "You win! (press space)";
    }
    super.update(dt);
  }

  void restartGame() async {
    GameWorld parentAsGameWorld = parent as GameWorld;

    // ignore: invalid_use_of_internal_member
    children.removeWhere((child) {
      if (child is Enemy) {
        child.entity.hitBox.removeFromParent();
        return true;
      }
      return false;
    });
    // ignore: invalid_use_of_internal_member
    children.removeWhere((child) => child is Bullet);

    parentAsGameWorld.points = 0;

    // re setup Player
    parentAsGameWorld.player.active = true;
    parentAsGameWorld.player.entity.health = 3;
    parentAsGameWorld.playerHealthUI.text =
        "HP: ${parentAsGameWorld.player.entity.health}";
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
  }

  void setHealthUI(String health) {
    GameWorld parentAsGameWorld = parent as GameWorld;
    parentAsGameWorld.playerHealthUI.text = "HP: $health";
  }
}
