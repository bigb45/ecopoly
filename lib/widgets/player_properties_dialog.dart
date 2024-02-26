import 'package:ecopoly/game_logic/game_manager.dart';
import 'package:ecopoly/models/player.dart';
import 'package:flutter/material.dart';

import 'trade_dialog.dart';

class PlayerPropertiesDialog extends StatelessWidget {
  final Player player;
  final GameManager gameManager;

  const PlayerPropertiesDialog({
    Key? key,
    required this.player,
    required this.gameManager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // scrollable: true,
      title: Column(
        children: [
          Text('${player.name}\'s Properties'),
          Text(
            "Money: \$${player.money}",
            style: const TextStyle(color: Colors.black, fontSize: 14),
          ),
        ],
      ),
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[100],
        ),
        width: MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: player.properties.map((property) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
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
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
      actions: [
        if (player.index != gameManager.currentPlayer.index)
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => TradeDialog(
                  targetPlayer: player,
                  currentPlayer: gameManager.currentPlayer,
                ),
              );
            },
            child: const Text("Offer Trade"),
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
