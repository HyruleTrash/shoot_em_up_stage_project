import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:shoot_em_up_stage_project/game/data/datasources/remote_data_source.dart';
import 'package:shoot_em_up_stage_project/game/presentation/bloc/game_bloc.dart';
import 'package:shoot_em_up_stage_project/game/presentation/widgets/player_widget.dart';
import 'package:shoot_em_up_stage_project/game/game_world.dart';

class ShootEmUpStageProject extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  ShootEmUpStageProject({dimensions = const Size(360, 640)});

  @override
  Color backgroundColor() => Color.fromARGB(255, 21, 0, 60);

  late final CameraComponent cam;
  Player player = Player();
  GameBloc gameBloc = GameBloc();

  World world = World();

  @override
  FutureOr<void> onLoad() async {
    // load all images into cache
    await images.loadAllImages();

    world = GameWorld(player: player, gameBloc: gameBloc);

    cam = CameraComponent.withFixedResolution(
        world: world, width: 360, height: 640);
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);

    return super.onLoad();
  }
}
