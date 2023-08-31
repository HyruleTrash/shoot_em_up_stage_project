import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class BulletEntity extends Component {
  double moveSpeed;
  double damage;
  bool active = true;
  BulletEntity({this.moveSpeed = 20, this.damage = 1});
  final RectangleHitbox hitBox = RectangleHitbox(
      size: Vector2(7, 32), position: Vector2(16, 16), anchor: Anchor.center);
}
