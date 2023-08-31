import 'package:equatable/equatable.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

final class lessenHP extends GameEvent {}

final class addPoint extends GameEvent {}

final class resetHP extends GameEvent {}

final class resetPoints extends GameEvent {}

final class setStatusLost extends GameEvent {}

final class setStatusWon extends GameEvent {}

final class setStatusPlaying extends GameEvent {}

final class getHttp extends GameEvent {}
