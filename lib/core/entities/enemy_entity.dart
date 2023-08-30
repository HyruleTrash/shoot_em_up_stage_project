import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class EnemyEntity extends Component {
  double moveSpeed = 50;
  double damageTaken = 0;
  double maxDamage = 3;

  final RectangleHitbox hitBox = RectangleHitbox(
      size: Vector2(32, 32), position: Vector2(0, 0), anchor: Anchor.center);
}
