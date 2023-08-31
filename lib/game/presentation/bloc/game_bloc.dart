import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoot_em_up_stage_project/game/data/datasources/remote_data_source.dart';
import 'package:shoot_em_up_stage_project/game/data/repositories/data_repository.dart';

import 'package:shoot_em_up_stage_project/game/presentation/bloc/game_event.dart';
import 'package:shoot_em_up_stage_project/game/presentation/bloc/game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final DataRepository dataRepository = DataRepository(RemoteDataSource());

  GameBloc()
      : super(const GameState(
            hp: 3, points: 0, status: GameStatus.playing, httpResult: "")) {
    on<lessenHP>((event, emit) {
      emit(GameState(
          hp: state.hp - 1,
          points: state.points,
          status: state.status,
          httpResult: state.httpResult));
    });
    on<addPoint>((event, emit) {
      emit(GameState(
          hp: state.hp,
          points: state.points + 1,
          status: state.status,
          httpResult: state.httpResult));
    });
    on<resetHP>((event, emit) {
      emit(GameState(
          hp: 3,
          points: state.points,
          status: state.status,
          httpResult: state.httpResult));
    });
    on<resetPoints>((event, emit) {
      emit(GameState(
          hp: state.hp,
          points: 0,
          status: state.status,
          httpResult: state.httpResult));
    });
    on<setStatusLost>((event, emit) {
      emit(GameState(
          hp: state.hp,
          points: state.points,
          status: GameStatus.lost,
          httpResult: state.httpResult));
    });
    on<setStatusWon>((event, emit) {
      emit(GameState(
          hp: state.hp,
          points: state.points,
          status: GameStatus.won,
          httpResult: state.httpResult));
    });
    on<setStatusPlaying>((event, emit) {
      emit(GameState(
          hp: state.hp,
          points: state.points,
          status: GameStatus.playing,
          httpResult: state.httpResult));
    });
    on<getHttp>((event, emit) async {
      GameState newState = await dataRepository.fetchData(state);
      emit(newState);
    });
  }
}


/* OLD FETCH SCRIPT, KEPT FOR MEMORY'S SAKE. IT'S A PERSONAL PROJECT SO I CAN DO THIS MWAHAHAHAHA
Future<GameState> fetchData(GameState state) async {
  final completer = Completer<GameState>(); // Create a completer

  final request = HttpRequest();
  request.open('GET', 'https://api.chucknorris.io/jokes/random');

  // Listen to the onLoad event
  request.onLoad.listen((event) {
    if (request.status == 200) {
      // Success
      final response = json.decode(request.responseText ?? "")['value'];
      final newState = GameState(
        hp: state.hp,
        points: state.points,
        status: state.status,
        httpResult: response,
      );
      completer.complete(newState); // Complete the future with the new state
    } else {
      // Failed
      final response = state.httpResult ?? "";
      final newState = GameState(
        hp: state.hp,
        points: state.points,
        status: state.status,
        httpResult: response,
      );
      completer
          .complete(newState); // Complete the future with the current state
    }
  });

  request.send();

  final newGameState =
      await completer.future; // Wait for the future to complete
  print(newGameState.httpResult);
  return newGameState;
}*/
