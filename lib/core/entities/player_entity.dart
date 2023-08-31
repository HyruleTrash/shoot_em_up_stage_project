import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class PlayerEntity extends Component {
  double moveSpeed = 200;

  double shootInterval = 0.2;
  double bulletSpeed = 350;

  final RectangleHitbox hitBox = RectangleHitbox(
      size: Vector2(32, 32), position: Vector2(0, 0), anchor: Anchor.center);
}
