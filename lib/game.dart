// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, unused_local_variable, avoid_print

import 'package:ecopoly/models/player.dart';
import 'package:ecopoly/util/player_position.dart';
import 'package:ecopoly/widgets/content_widget.dart';
import 'package:ecopoly/widgets/trade_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import 'package:ecopoly/animations/animated_scale_fade.dart';
import 'package:ecopoly/game_logic/game_manager.dart';
import 'package:ecopoly/util/board.dart';
import 'package:ecopoly/widgets/blurry_container.dart';
import 'package:ecopoly/widgets/cell_details.dart';
import 'package:provider/provider.dart';

import 'board_cells.dart';
import 'widgets/player_model.dart';
import 'widgets/player_properties_dialog.dart';
import 'widgets/players_information.dart';

const double width = 80;
const double height = 60;
const playerSize = 18.0;
const gridWidth = 11;

class GameScreen extends StatefulWidget {
  final TransformationController interactiveBoardController;

  const GameScreen({
    super.key,
    required this.interactiveBoardController,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool infoCardOpen = false;
  int infoCardIndex = 0;

  void onCityClick(int index) {
    setState(() {
      infoCardOpen = true;
      infoCardIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameManager = Provider.of<GameManager>(context);
    return Scaffold(
      body: Container(
        color: Color(int.parse("0xFF130F3D")),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Center(
                child: FittedBox(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color:
                              ColorScheme.fromSeed(seedColor: Colors.deepPurple)
                                  .primaryContainer,
                        ),
                        child: LayoutGrid(
                          areas: '''
                                  go       city1   jail
                                  city3    content city2
                                  gotojail city4   parking
                                ''',
                          columnSizes: const [auto, auto, auto],
                          rowSizes: const [auto, auto, auto],
                          columnGap: 0,
                          rowGap: 0,
                          children: [
                            ContentWidget().inGridArea('content'),
                            start().inGridArea('go'),
                            BoardRow(
                                index: 0,
                                cities: board.sublist(1, 10),
                                onCityClick: ((index) =>
                                    onCityClick(index))).inGridArea('city1'),
                            BoardColumn(
                                index: 1,
                                cities: board.sublist(11, 20),
                                onCityClick: ((index) =>
                                    onCityClick(index))).inGridArea('city2'),
                            BoardRow(
                                index: 2,
                                cities: board.sublist(21, 30),
                                onCityClick: ((index) =>
                                    onCityClick(index))).inGridArea('city4'),
                            BoardColumn(
                                index: 3,
                                cities: board.sublist(31),
                                onCityClick: ((index) =>
                                    onCityClick(index))).inGridArea('city3'),
                            jail().inGridArea('jail'),
                            jail().inGridArea('gotojail'),
                            jail().inGridArea('parking')
                          ],
                        ),
                      ),
                      ...gameManager.players.map(
                        (player) {
                          double playerDirection =
                              getDirection(player.position);
                          double top = 0;
                          double left = 0;
                          int position = player.position ~/ 10;

                          if (position % 2 == 0) {
                            bool topOrBottom = position == 2;

                            left = width +
                                height *
                                    ((topOrBottom
                                            ? 10 - player.position % 10
                                            : player.position % 10) -
                                        1) +
                                (height - playerSize) / 2;
                            top = width / 2 +
                                (topOrBottom
                                    ? height * 10 + playerSize / 2
                                    : -playerSize / 2);
                          } else {
                            bool leftOrRight = position == 3;

                            top = width +
                                height *
                                    ((leftOrRight
                                            ? 10 - player.position % 10
                                            : player.position % 10) -
                                        1) +
                                (height - playerSize) / 2;
                            left = (leftOrRight
                                ? (width - playerSize) / 2
                                : height * 10 + (width + playerSize) / 2);
                          }

                          return Builder(
                            builder: (context) {
                              if (player.index !=
                                  gameManager.currentPlayer.index) {
                                int yOffset = switch (player.index) {
                                  0 => -10,
                                  1 => 10,
                                  2 => -10,
                                  3 => 10,
                                  int() => 0
                                };
                                int xOffset = switch (player.index) {
                                  0 => -10,
                                  1 => 10,
                                  2 => 10,
                                  3 => -10,
                                  int() => 0
                                };
                                int inJailOffset = player.isInJail ? 20 : 0;
                                return AnimatedPositioned(
                                  duration: Duration(milliseconds: 600),
                                  curve: Curves.easeInOut,
                                  top: top + xOffset,
                                  left: left + yOffset,
                                  child: Transform.rotate(
                                    angle: playerDirection,
                                    child: playerModel(player.color),
                                  ),
                                );
                              } else {
                                return AnimatedPositioned(
                                  duration: Duration(milliseconds: 600),
                                  curve: Curves.easeInOutCubic,
                                  top: top,
                                  left: left,
                                  child: AnimatedScaleFade(
                                    duration: Duration(milliseconds: 600),
                                    curve: Curves.easeInOut,
                                    scale: 1.7,
                                    child: Transform.rotate(
                                      angle: playerDirection,
                                      child: playerModel(player.color),
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ).toList(),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                PlayersInformation(
                  onPlayerClick: (player) {
                    showDialog(
                      context: context,
                      builder: (con) => PlayerPropertiesDialog(
                        outerContext: context,
                        playerIndex: player.index,
                        gameManager: gameManager,
                      ),
                    );
                  },
                ),
                AnimatedOpacity(
                  opacity: infoCardOpen ? 1 : 0,
                  duration: Duration(milliseconds: 400),
                  child: Visibility(
                    visible: infoCardOpen,
                    child: CellDetails(
                      cardIndex: infoCardIndex,
                      currentPlayerIndex: gameManager.currentPlayer.index,
                      onClose: () {
                        setState(() {
                          infoCardOpen = false;
                          print("closed");
                        });
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

dialogTest(BuildContext context, int playerIndex) {
  final GameManager gameManager =
      Provider.of<GameManager>(context, listen: false);
  Player player = gameManager.players.firstWhere((p) => p.index == playerIndex);
  return showDialog(
    context: context,
    builder: (_) => ChangeNotifierProvider.value(
      value: gameManager,
      child: AlertDialog(
        title: Column(
          children: [
            Text('${player.name}\'s Properties'),
            Text(
              "Money: \$${player.money}",
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
          ],
        ),
        content: Builder(builder: (context) {
          if (player.properties.isEmpty) {
            return const Center(
              child: Text(
                "No properties owned",
                style: TextStyle(color: Colors.black),
              ),
            );
          }
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
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
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        }),
        actions: [
          if (player.index != gameManager.currentPlayer.index)
            ElevatedButton(
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
              child: const Text("Offer Trade"),
            ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    ),
  );
}

Widget start() {
  return BlurryContainer(
    width: width,
    height: width,
    blurStrength: 0,
    cell: board[0],
    child: Text(
      'Start',
      style: TextStyle(
        fontSize: 18,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    ),
  );
}

Widget jail({GameManager? gameManager}) {
  return BlurryContainer(
    width: width,
    height: width,
    blurStrength: 0,
    cell: board[0],
    child: Text(
      'Jail',
      style: TextStyle(
        fontSize: 18,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    ),
  );
}
