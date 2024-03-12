// ignore_for_file: avoid_print

import 'dart:math';

import 'package:ecopoly/game.dart';
import 'package:ecopoly/game_logic/game_manager.dart';
import 'package:ecopoly/game_logic/simulated_game_manager.dart';
import 'package:ecopoly/models/player.dart';
import 'package:ecopoly/models/property.dart';
import 'package:ecopoly/util/board.dart';
import 'package:ecopoly/widgets/game_button.dart';
import 'package:ecopoly/widgets/player_number_selector.dart';
import 'package:ecopoly/widgets/simulated_game_board.dart';
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
      create: (context) => GameManager(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EcoPoly',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => ChangeNotifierProvider(
                create: (context) => SimulatedGameManager(),
                child: MainMenuScreen(
                  onPlayersSelected: (players) {
                    print('Player count: ${players.length}');
                    Provider.of<GameManager>(context, listen: false)
                        .setPlayers(players);
                  },
                ),
              ),
          '/game': (context) => const GameScreen(),
        },
      ),
    );
  }
}

class MainMenuScreen extends StatefulWidget {
  final Function(List<Player>) onPlayersSelected;
  const MainMenuScreen({super.key, required this.onPlayersSelected});

  @override
  MainMenuScreenState createState() => MainMenuScreenState();
}

class MainMenuScreenState extends State<MainMenuScreen> {
  bool _navigationOccurred = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      simulateGame(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GameButton(
                      onPressed: () {
                        for (var element in board) {
                          if (element is Property) {
                            element.owner = null;
                          }
                        }
                        _navigationOccurred = true;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GameScreen(),
                          ),
                        );
                      },
                      leading: const Icon(Icons.play_circle_fill,
                          color: Colors.white),
                      childText: 'Start Game',
                    ),
                    const SizedBox(height: 20),
                    PlayerNumberSelector(onPlayersChange: (players) {
                      widget.onPlayersSelected(players);
                    }),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: IgnorePointer(
                  child: SimulatedGameBoard(
                      gameManager: Provider.of<SimulatedGameManager>(context)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> simulateGame(BuildContext context) async {
    SimulatedGameManager gameManager =
        Provider.of<SimulatedGameManager>(context, listen: false);
    const numberOfIterations = 10;
    if (_navigationOccurred) {
      return;
    }
    await startGame(gameManager);

    for (int i = 0; i < numberOfIterations; i++) {
      if (_navigationOccurred) {
        // dispose();
        return;
      }
      await rollDice(gameManager);
      if (gameManager.canBuyProperty) {
        await buyProperty(gameManager);
      }
      await endTurn(gameManager);
    }
    return;
  }

  Future<void> startGame(SimulatedGameManager gameManager) async {
    print('Starting the game...');
    await Future.delayed(const Duration(seconds: 3)); // Simulating delay
    if (!_navigationOccurred) {
      gameManager.startGame();
    }
  }

  Future<void> rollDice(SimulatedGameManager gameManager) async {
    // Simulate rolling the dice
    print('Rolling the dice...');
    await Future.delayed(
        Duration(seconds: Random().nextInt(2) + 3)); // Simulating delay
    if (!_navigationOccurred) {
      gameManager.rollDice();
    }
  }

  Future<void> buyProperty(SimulatedGameManager gameManager) async {
    // Simulate buying property
    print('Buying property...');
    await Future.delayed(const Duration(seconds: 3)); // Simulating delay
    if (!_navigationOccurred) {
      gameManager.buyProperty();
    }
  }

  Future<void> endTurn(SimulatedGameManager gameManager) async {
    // Simulate ending the turn
    print('Ending the turn...');
    await Future.delayed(
        Duration(seconds: Random().nextInt(3) + 3)); // Simulating delay
    if (!_navigationOccurred) {
      gameManager.endTurn();
    }
  }
}
