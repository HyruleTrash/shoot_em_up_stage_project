import 'package:flame/components.dart';

class BulletEntity extends Component {
  double moveSpeed;
  double damage;
  bool active = true;
  BulletEntity({this.moveSpeed = 20, this.damage = 1});
}
