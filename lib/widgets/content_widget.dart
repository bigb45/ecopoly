import 'dart:async';
import 'dart:math';

import 'package:ecopoly/game_logic/game_manager.dart';
import 'package:ecopoly/models/game_event.dart';
import 'package:ecopoly/models/player.dart';
import 'package:ecopoly/models/property.dart';
import 'package:ecopoly/util/animated_visibility.dart';
import 'package:ecopoly/util/board.dart';
import 'package:ecopoly/widgets/dice.dart';
import 'package:ecopoly/widgets/game_button.dart';
import 'package:ecopoly/widgets/player_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentWidget extends StatefulWidget {
  const ContentWidget({
    Key? key,
  }) : super(key: key);

  @override
  _ContentWidgetState createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  late Timer _timer;
  late int _secondDieValue;
  late int _firstDieValue;
  late bool _isRolling;
  @override
  void initState() {
    super.initState();
    _secondDieValue = 1;
    _firstDieValue = 1;
    _isRolling = false;
  }

  void _rollDice() {
    final gameManager = Provider.of<GameManager>(context, listen: false);

    if (!_isRolling && !gameManager.rolledDice && gameManager.gameStarted) {
      setState(() {
        _isRolling = true;
      });

      _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        if (mounted) {
          setState(() {
            _secondDieValue = Random().nextInt(6) + 1;
            _firstDieValue = Random().nextInt(6) + 1;
          });
        }
      });

      Timer(const Duration(seconds: 1), () {
        setState(() {
          gameManager.rollDice();
          _firstDieValue = gameManager.firstDie;
          _secondDieValue = gameManager.secondDie;
          _timer.cancel();
          _isRolling = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameManager>(builder: (context, gameManager, _) {
      return Container(
        color: Color(int.parse("0xFF130F2D")),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              GestureDetector(
                onTap: _rollDice,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Dice(
                      value: _firstDieValue,
                      canRoll: !gameManager.rolledDice,
                      playerColor: gameManager.currentPlayer.color),
                  const SizedBox(width: 20),
                  Dice(
                      value: _secondDieValue,
                      canRoll: !gameManager.rolledDice,
                      playerColor: gameManager.currentPlayer.color),
                ]),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!gameManager.gameStarted)
                    AnimatedVisibility(
                      visible: !gameManager.gameStarted,
                      child: GameButton(
                        childText: "Start Game",
                        onPressed: () {
                          gameManager.startGame();
                        },
                      ),
                    ),
                  if (gameManager.gameStarted && !gameManager.rolledDice)
                    const SizedBox(
                      width: 20,
                    ),
                  if (gameManager.gameStarted && !gameManager.rolledDice)
                    AnimatedVisibility(
                      visible: gameManager.gameStarted && !_isRolling,
                      child: GameButton(
                          onPressed: !gameManager.rolledDice
                              ? () {
                                  _rollDice();
                                }
                              : null,
                          childText: "Roll dice"),
                    ),
                  if (gameManager.rolledDice)
                    const SizedBox(
                      width: 20,
                    ),
                  if (gameManager.rolledDice)
                    AnimatedVisibility(
                      visible: gameManager.rolledDice,
                      child: GameButton(
                        onPressed: gameManager.currentPlayer.money >= 0
                            ? () {
                                gameManager.endTurn();
                                // _showAnimatedDialog(
                                //     context,
                                //     gameManager.currentPlayer.name,
                                //     gameManager.currentPlayer.color);
                              }
                            : null,
                        childText: "End turn",
                      ),
                    ),
                  if (gameManager.canBuyProperty)
                    const SizedBox(
                      width: 20,
                    ),
                  if (gameManager.canBuyProperty)
                    AnimatedVisibility(
                      visible: gameManager.canBuyProperty,
                      child: GameButton(
                          onPressed: gameManager.canBuyProperty &&
                                  gameManager.currentPlayer.money >=
                                      (board[gameManager.currentPlayer.position]
                                              as Property)
                                          .cost
                              ? () {
                                  gameManager.buyProperty();
                                }
                              : null,
                          childText: "Buy Property"),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Color(int.parse("0xFF130F2D")).withOpacity(0.7),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...gameManager.gameEvents
                              .asMap()
                              .entries
                              .map((entry) {
                            final index = entry.key;
                            final event = entry.value;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                              child: Opacity(
                                opacity: index == 0
                                    ? 1.0
                                    : 0.5, // Adjust opacity as needed
                                child: getMessageFromEvent(event),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

Widget getMessageFromEvent(GameEvent event) {
  switch (event.type) {
    case EventType.offerTrade:
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          playerInText(event.firstPlayer),
          const Text(
            " offered ",
            style: TextStyle(color: Colors.white),
          ),
          playerInText(event.secondPlayer!),
          const Text(
            " A trade.",
            style: TextStyle(color: Colors.white),
          )
        ],
      );
    // case EventType.acceptTrade:
    //   return '${event.firstPlayer.name} traded ${event.property!.name} with ${event.secondPlayer!.name}';
    case EventType.purchase:
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          playerInText(event.firstPlayer),
          const Text(
            " bought ",
            style: TextStyle(color: Colors.white),
          ),
          propertyInText(event.property!),
        ],
      );

    case EventType.rent:
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          playerInText(event.firstPlayer),
          Text(
            " paid \$${event.amount ?? 200} ",
            style: const TextStyle(color: Colors.white),
          ),
          const Text(
            " to ",
            style: TextStyle(color: Colors.white),
          ),
          playerInText(event.secondPlayer!),
        ],
      );
    case EventType.tax:
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          playerInText(event.firstPlayer),
          Text(
            " paid \$${event.amount} in tax",
            style: const TextStyle(color: Colors.white),
          ),
        ],
      );
    case EventType.goToJail:
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          playerInText(event.firstPlayer),
          const Text(
            " landed on Go To Jail ",
            style: TextStyle(color: Colors.white),
          ),
        ],
      );

    case EventType.tax:
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          playerInText(event.firstPlayer),
          Text(
            " paid a tax of \$${event.amount!} ",
            style: const TextStyle(color: Colors.white),
          ),
        ],
      );

    case EventType.go:
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          playerInText(event.firstPlayer),
          const Text(
            " landed on Start and received \$300 ",
            style: TextStyle(color: Colors.white),
          ),
        ],
      );

    case EventType.passGo:
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          playerInText(event.firstPlayer),
          const Text(
            " passed Start and received \$300 ",
            style: TextStyle(color: Colors.white),
          ),
        ],
      );
    case EventType.gameStart:
      return const Text('The game has started');
    case EventType.surprise:
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          playerInText(event.firstPlayer),
          Flexible(
            fit: FlexFit.loose,
            child: Text(
              " received a surprise card: ${event.message!}",
              style: const TextStyle(color: Colors.white),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    case EventType.charity:
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          playerInText(event.firstPlayer),
          Flexible(
            fit: FlexFit.loose,
            child: Text(
              " received a charity card: ${event.message!} ",
              style: const TextStyle(color: Colors.white),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );

    default:
      return const SizedBox();
  }
}

Widget propertyInText(Property property) {
  return Row(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: SizedBox(
          height: 24,
          width: 24,
          child: Image.asset(property.imageName),
        ),
      ),
      const SizedBox(
        width: 4,
      ),
      Text(
        property.name,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      )
    ],
  );
}

Widget playerInText(Player player) {
  return Row(
    children: [
      Transform.scale(scale: 1, child: playerModel(player.color)),
      const SizedBox(
        width: 4,
      ),
      Text(
        player.name,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      )
    ],
  );
}

void _showAnimatedDialog(
    BuildContext context, String playerName, Color playerColor) {
  Timer? timer = Timer(const Duration(milliseconds: 3000), () {
    Navigator.of(context, rootNavigator: true).pop();
  });
  showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.7),
      transitionBuilder: (context, a1, a2, widget) {
        return Opacity(
          opacity: a1.value,
          child: DefaultTextStyle(
            style: const TextStyle(color: Colors.white),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: playerColor.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                    BoxShadow(
                      color: playerColor.withOpacity(0.3),
                      blurRadius: 50,
                      spreadRadius: 5,
                      offset: const Offset(0, 0),
                    ),
                    BoxShadow(
                      color: playerColor.withOpacity(0.5),
                      blurRadius: 60,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Text(
                  "Pass the phone to $playerName",
                  style: TextStyle(
                    shadows: [
                      Shadow(
                        color: playerColor.withOpacity(0.8),
                        blurRadius: 10,
                        offset: const Offset(0, 0),
                      ),
                      Shadow(
                        color: playerColor.withOpacity(0.6),
                        blurRadius: 20,
                        offset: const Offset(0, 0),
                      ),
                      Shadow(
                        color: playerColor.withOpacity(0.4),
                        blurRadius: 30,
                        offset: const Offset(0, 0),
                      ),
                    ],
                    color: Colors.white,
                    fontSize: 32,
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return const SizedBox();
      }).then((value) {
    // dispose the timer in case something else has triggered the dismiss.
    timer?.cancel();
    timer = null;
  });
}
