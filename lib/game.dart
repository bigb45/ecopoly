// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, unused_local_variable, avoid_print

import 'package:ecopoly/util/player_position.dart';
import 'package:ecopoly/widgets/animated_shadow_container.dart';
import 'package:ecopoly/widgets/content_widget.dart';
import 'package:ecopoly/widgets/game_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import 'package:ecopoly/animations/animated_scale_fade.dart';
import 'package:ecopoly/game_logic/game_manager.dart';
import 'package:ecopoly/util/board.dart';
import 'package:ecopoly/widgets/blurry_container.dart';
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
  @override
  Widget build(BuildContext context) {
    final gameManager = Provider.of<GameManager>(context);
    return Scaffold(
      body: Container(
        color: Color(int.parse("0xFF130F3D")),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
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
                                      gameManager.openInfoCard(index)))
                              .inGridArea('city1'),
                          BoardColumn(
                                  index: 1,
                                  cities: board.sublist(11, 20),
                                  onCityClick: ((index) =>
                                      gameManager.openInfoCard(index)))
                              .inGridArea('city2'),
                          BoardRow(
                                  index: 2,
                                  cities: board.sublist(21, 30),
                                  onCityClick: ((index) =>
                                      gameManager.openInfoCard(index)))
                              .inGridArea('city4'),
                          BoardColumn(
                                  index: 3,
                                  cities: board.sublist(31),
                                  onCityClick: ((index) =>
                                      gameManager.openInfoCard(index)))
                              .inGridArea('city3'),
                          jail().inGridArea('jail'),
                          jail().inGridArea('gotojail'),
                          jail().inGridArea('parking')
                        ],
                      ),
                    ),
                    ...gameManager.players.map(
                      (player) {
                        double playerDirection = getDirection(player.position);
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
            const SizedBox(
              width: 30,
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
                const Spacer(),
                GameControls(gameManager: gameManager),
                const Spacer(),
              ],
            ),
            // const Spacer(),
          ],
        ),
      ),
    );
  }
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
