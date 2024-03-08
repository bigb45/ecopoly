import 'dart:async';
import 'dart:math';

import 'package:ecopoly/game_logic/game_manager.dart';
import 'package:ecopoly/models/property.dart';
import 'package:ecopoly/util/board.dart';
import 'package:ecopoly/widgets/dice.dart';
import 'package:ecopoly/widgets/game_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameControls extends StatefulWidget {
  final GameManager gameManager;
  const GameControls({super.key, required this.gameManager});

  @override
  State<GameControls> createState() => GameControlsState();
}

class GameControlsState extends State<GameControls> {
  late Timer _timer;
  late int _secondDieValue;
  late int _firstDieValue;
  late bool _isRolling;
  late GameManager gameManager;

  @override
  void initState() {
    super.initState();
    _secondDieValue = 1;
    _firstDieValue = 1;
    _isRolling = false;
    gameManager = widget.gameManager;
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
        gameManager.rollDice();
        setState(() {
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
    return Column(
      children: [
        GestureDetector(
          onTap: _rollDice,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
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
            if (gameManager.currentPlayer.isInJail)
              GameButton(
                childText: "Get out for \$50",
                onPressed: gameManager.currentPlayer.money >= 50
                    ? () {
                        gameManager.getOutOfJail();
                      }
                    : null,
              ),
            if (!gameManager.gameStarted)
              GameButton(
                childText: "Start Game",
                onPressed: () {
                  gameManager.startGame();
                },
              ),
            if (gameManager.gameStarted && !gameManager.rolledDice)
              const SizedBox(
                width: 20,
              ),
            if (gameManager.gameStarted && !gameManager.rolledDice)
              GameButton(
                  onPressed: !gameManager.rolledDice
                      ? () {
                          _rollDice();
                        }
                      : null,
                  childText: "Roll dice"),
            if (gameManager.rolledDice)
              const SizedBox(
                width: 20,
              ),
            if (gameManager.rolledDice)
              GameButton(
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
            if (gameManager.canBuyProperty)
              const SizedBox(
                width: 20,
              ),
            if (gameManager.canBuyProperty)
              GameButton(
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
          ],
        ),
      ],
    );
  }
}
