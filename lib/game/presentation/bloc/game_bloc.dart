import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shoot_em_up_stage_project/game/presentation/bloc/game_event.dart';
import 'package:shoot_em_up_stage_project/game/presentation/bloc/game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(GameState(hp: 3, points: 0, status: GameStatus.playing));

  @override
  Stream<GameState> mapEventToState(GameEvent event) async* {
    GameState currentState = state;

    switch (event) {
      case GameEvent.lessenHP:
        break;
      case GameEvent.addPoint:
        break;
      case GameEvent.resetHP:
        break;
      case GameEvent.resetPoints:
        break;
      case GameEvent.setStatusLost:
        break;
      case GameEvent.setStatusWon:
        break;
      case GameEvent.setStatusPlaying:
        break;
      default:
    }
  }
}
