import 'dart:async';
import 'dart:math';

import 'package:ecopoly/game_logic/game_manager.dart';
import 'package:ecopoly/models/property.dart';
import 'package:ecopoly/util/board.dart';
import 'package:ecopoly/widgets/dice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentWidget extends StatefulWidget {
  final VoidCallback rollDice;
  final VoidCallback endTurn;
  final VoidCallback buyProperty;
  final VoidCallback startGame;

  const ContentWidget({
    Key? key,
    required this.rollDice,
    required this.endTurn,
    required this.buyProperty,
    required this.startGame,
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
        setState(() {
          _secondDieValue = Random().nextInt(6) + 1;
          _firstDieValue = Random().nextInt(6) + 1;
        });
      });

      Timer(const Duration(seconds: 1), () {
        setState(() {
          widget.rollDice();
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
    final gameManager = Provider.of<GameManager>(context, listen: false);

    return Container(
      color: Color(int.parse("0xFF130F2D")),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _rollDice,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Dice(value: _firstDieValue, canRoll: !gameManager.rolledDice),
                const SizedBox(width: 20),
                Dice(value: _secondDieValue, canRoll: !gameManager.rolledDice),
              ]),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!gameManager.gameStarted)
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    onPressed: () {
                      widget.startGame();
                    },
                    child: const Text("Start game"),
                  ),
                if (gameManager.gameStarted && !gameManager.rolledDice)
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: gameManager.rolledDice ? 0 : 1,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      onPressed: !gameManager.rolledDice
                          ? () {
                              _rollDice();
                            }
                          : null,
                      child: const Text("Roll dice"),
                    ),
                  ),
                if (gameManager.rolledDice)
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    onPressed: gameManager.currentPlayer.money >= 0
                        ? () {
                            widget.endTurn();
                          }
                        : null,
                    child: const Text("End turn"),
                  ),
                if (gameManager.canBuyProperty)
                  const SizedBox(
                    width: 20,
                  ),
                if (gameManager.canBuyProperty)
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      onPressed: gameManager.currentPlayer.money >=
                              (board[gameManager.currentPlayer.position]
                                      as Property)
                                  .cost
                          ? () {
                              widget.buyProperty();
                            }
                          : null,
                      child: const Text("Buy Property"))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
