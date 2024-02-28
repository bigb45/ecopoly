import 'package:ecopoly/animations/animated_zoom_pan.dart';
import 'package:ecopoly/game.dart';
import 'package:ecopoly/game_logic/game_manager.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final boardTransformationController = TransformationController();
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ChangeNotifierProvider(
        create: (context) => GameManager()..setPlayers(2),
        child: AnimatedZoomPan(
          transformationController: boardTransformationController,
          child: InteractiveViewer(
            transformationController: boardTransformationController,
            child: GameScreen(
              interactiveBoardController: boardTransformationController,
            ),
          ),
        ),
      ),
    );
  }
}
