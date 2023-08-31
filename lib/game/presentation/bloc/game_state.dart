import 'package:equatable/equatable.dart';

enum GameStatus { playing, won, lost }

class GameState extends Equatable {
  final int hp;
  final int points;
  final GameStatus status;
  final String? httpResult;

  const GameState(
      {required this.hp,
      required this.points,
      required this.status,
      required this.httpResult});

  GameState copyWith(
      {int? hp, int? points, GameStatus? status, String? httpResult}) {
    return GameState(
        hp: hp ?? this.hp,
        points: points ?? this.points,
        status: status ?? this.status,
        httpResult: httpResult ?? this.httpResult);
  }

  @override
  List<Object?> get props => [hp, points, status, httpResult];
}
