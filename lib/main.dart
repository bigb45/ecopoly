// ignore_for_file: avoid_print

import 'package:ecopoly/game.dart';
import 'package:ecopoly/game_logic/game_manager.dart';
import 'package:ecopoly/widgets/game_button.dart';
import 'package:ecopoly/widgets/player_model.dart';
import 'package:ecopoly/widgets/player_number_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameManager()..setPlayers(2),
      child: MaterialApp(
        title: 'EcoPoly',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const MainMenuScreen(),
          '/game': (context) => const GameScreen(),
        },
      ),
    );
  }
}

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // GameManager gameManager = Provider.of<GameManager>(context);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
                child: Image.asset(
              "assets/images/ecopoly.png",
              fit: BoxFit.fill,
            )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GameButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider(
                              create: (context) => GameManager()..setPlayers(2),
                              child: const GameScreen(),
                            ),
                          ),
                        );
                      },
                      leading: const Icon(Icons.play_circle_fill,
                          color: Colors.white),
                      childText: 'Start Game',
                    ),
                    const SizedBox(height: 20),
                    PlayerNumberSelector(onPlayerNumberChange: (playerCount) {
                      print("player count: $playerCount");
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
