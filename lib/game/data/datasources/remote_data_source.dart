import 'package:shoot_em_up_stage_project/game/data/repositories/data_repository.dart';
import 'package:shoot_em_up_stage_project/game/presentation/bloc/game_state.dart';

class DataRepository {
  final RemoteDataSource remoteDataSource;

  DataRepository(this.remoteDataSource);

  Future<GameState> fetchData(GameState state) async {
    final httpResult = await remoteDataSource.fetchDataFromUrl();
    final newState = state.copyWith(httpResult: httpResult);
    return newState;
  }
}
