import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoot_em_up_stage_project/shoot_em_up_stage_project.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // creates window
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shoot Em Up Stage Project Lucas',
      debugShowCheckedModeBanner: false, // Remove the debug banner
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        body: Center(
          child: Container(
            width: 360,
            height: 640,
            child: GameWidget(game: ShootEmUpStageProject()),
          ),
        ),
      ),
    );
  }
}
