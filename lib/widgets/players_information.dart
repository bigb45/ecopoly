// ignore_for_file: must_be_immutable

import 'package:animated_digit/animated_digit.dart';
import 'package:ecopoly/game_logic/game_manager.dart';
import 'package:ecopoly/models/player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'player_model.dart';

class PlayersInformation extends StatelessWidget {
  final Function(Player player) onPlayerClick;

  const PlayersInformation({
    Key? key,
    required this.onPlayerClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameManager = Provider.of<GameManager>(context, listen: false);
    final players = gameManager.players;

    const rowHeight = 35.0;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 160,
        height: players.length * rowHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.shade900,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              top: rowHeight *
                  gameManager.players.indexOf(gameManager.currentPlayer),
              left: 1,
              right: 1,
              child: Container(
                height: rowHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ...players.map((player) {
                  return GestureDetector(
                    onTap: () => onPlayerClick(player),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          playerModel(player.color),
                          Text(player.name,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white)),
                          AnimatedDigitWidget(
                            textStyle: const TextStyle(
                                fontSize: 12, color: Colors.green),
                            prefix: "\$",
                            value: player.money,
                            duration: const Duration(milliseconds: 1000),
                            valueColors: [
                              ValueColor(
                                condition: () => player.money <= 0,
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
