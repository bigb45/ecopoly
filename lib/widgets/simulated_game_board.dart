import 'package:ecopoly/animations/animated_scale_fade.dart';
import 'package:ecopoly/board_cells.dart';
import 'package:ecopoly/game.dart';
import 'package:ecopoly/game_logic/simulated_game_manager.dart';
import 'package:ecopoly/util/board.dart';
import 'package:ecopoly/util/player_position.dart';
import 'package:ecopoly/widgets/content.dart';
import 'package:ecopoly/widgets/player_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

class SimulatedGameBoard extends StatelessWidget {
  final SimulatedGameManager gameManager;
  const SimulatedGameBoard({super.key, required this.gameManager});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: ColorScheme.fromSeed(seedColor: Colors.deepPurple)
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
                const Content().inGridArea('content'),
                start().inGridArea('go'),
                BoardRow(
                        index: 0,
                        cities: board.sublist(1, 10),
                        onCityClick: ((placeholder) {}))
                    .inGridArea('city1'),
                BoardColumn(
                        index: 1,
                        cities: board.sublist(11, 20),
                        onCityClick: ((placeholder) {}))
                    .inGridArea('city2'),
                BoardRow(
                        index: 2,
                        cities: board.sublist(21, 30),
                        onCityClick: ((placeholder) {}))
                    .inGridArea('city4'),
                BoardColumn(
                        index: 3,
                        cities: board.sublist(31),
                        onCityClick: ((placeholder) {}))
                    .inGridArea('city3'),
                jail().inGridArea('jail'),
                goToJail().inGridArea('gotojail'),
                freeParking().inGridArea('parking')
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
                  if (player.index != gameManager.currentPlayer.index) {
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
    );
  }
}
