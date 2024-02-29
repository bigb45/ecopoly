// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ecopoly/widgets/game_button.dart';
import 'package:flutter/material.dart';

import 'package:ecopoly/game_logic/game_manager.dart';
import 'package:ecopoly/models/player.dart';
import 'package:provider/provider.dart';

import 'trade_dialog.dart';

class PlayerPropertiesDialog extends StatefulWidget {
  final int playerIndex;
  final GameManager gameManager;
  final BuildContext outerContext;
  const PlayerPropertiesDialog({
    required this.outerContext,
    Key? key,
    required this.playerIndex,
    required this.gameManager,
  }) : super(key: key);

  @override
  State<PlayerPropertiesDialog> createState() => _PlayerPropertiesDialogState();
}

class _PlayerPropertiesDialogState extends State<PlayerPropertiesDialog> {
  @override
  Widget build(BuildContext context) {
    final gameManager =
        Provider.of<GameManager>(widget.outerContext, listen: true);
    Player player = gameManager.players
        .firstWhere((element) => element.index == widget.playerIndex);
    return AlertDialog(
      backgroundColor: Colors.grey.shade900,
      title: Column(
        children: [
          Text(
            '${player.name}\'s Properties',
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            "Money: \$${player.money}",
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
      content: Builder(builder: (context) {
        if (player.properties.isEmpty) {
          return const Center(
            child: Text(
              "No properties owned",
              style: TextStyle(color: Colors.white),
            ),
          );
        }
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade900,
          ),
          width: MediaQuery.of(context).size.width * 0.4,
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: player.properties.map((property) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {});
                    },
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.asset(
                            property.imageName,
                            width: 30,
                            height: 30,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          property.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      }),
      actions: [
        if (player.index != gameManager.currentPlayer.index)
          GameButton(
            onPressed: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => TradeDialog(
                  currentPlayer: gameManager.currentPlayer,
                  targetPlayer: player,
                  onTradeCompleted: (trade) {
                    gameManager.addTrade(trade: trade);
                  },
                ),
              );
            },
            childText: "Offer Trade",
          ),
        if (player.index == gameManager.currentPlayer.index)
          GameButton(
            onPressed: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (BuildContext context) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AlertDialog(
                    backgroundColor: Colors.grey.shade900,
                    actionsAlignment: MainAxisAlignment.center,
                    content: const Text(
                      "Are you sure you want to Bankrupt?",
                      style: TextStyle(color: Colors.white),
                    ),
                    actions: [
                      GameButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        childText: "Cancel",
                      ),
                      GameButton(
                        onPressed: () {
                          gameManager.quit(gameManager.currentPlayer.index);

                          Navigator.pop(context);
                        },
                        childText: "Bankrupt",
                      ),
                    ],
                  ),
                ),
              );
            },
            childText: "Bankrupt",
          ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
