import 'package:equatable/equatable.dart';

enum GameStatus { playing, won, lost }

class GameState extends Equatable {
  final int hp;
  final int points;
  final GameStatus status;

  const GameState(
      {required this.hp, required this.points, required this.status});

  @override
  List<Object?> get props => [
        hp,
        points,
        status,
      ];
}
