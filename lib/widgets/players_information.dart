// ignore_for_file: must_be_immutable

import 'package:animated_digit/animated_digit.dart';
import 'package:ecopoly/game.dart';
import 'package:ecopoly/models/player.dart';
import 'package:flutter/material.dart';

import 'player_model.dart';

class PlayersInformation extends StatelessWidget {
  final List<Player> players;
  Function(Player player) onPlayerClick;
  int currentPlayerIndex = 0;
  PlayersInformation({
    super.key,
    required this.players,
    required this.currentPlayerIndex,
    required this.onPlayerClick,
  });
  @override
  Widget build(BuildContext context) {
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
              duration: Duration(milliseconds: 300),
              top: rowHeight * currentPlayerIndex,
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
                          // Text("${player.money}",
                          //     style: const TextStyle(
                          //         fontSize: 12, color: Colors.white)),
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
