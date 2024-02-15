// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, unused_local_variable, avoid_print
import 'dart:ui';

import 'package:ecopoly/game_logic/game_manager.dart';
import 'package:ecopoly/models/cell.dart';
import 'package:ecopoly/util/blurry_container.dart';
import 'package:ecopoly/util/board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import "dart:math";

const double width = 40;
const double height = 40;
const playerSize = 18.0;
const gridWidth = 11;

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  GameManager gameManager = GameManager();

  @override
  void initState() {
    super.initState();
    gameManager.setPlayers(4);
    gameManager.startGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(int.parse("0xFF130F1D")),
        child: Row(
          children: [
            Center(
              child: Transform.scale(
                scale: 1,
                child: Transform.translate(
                  offset: Offset(100, 0),
                  child: FittedBox(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            // border: Border.all(color: Colors.black, width: 1),
                            color: ColorScheme.fromSeed(
                                    seedColor: Colors.deepPurple)
                                .primaryContainer,
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.black.withOpacity(0.5),
                            //     spreadRadius: 5,
                            //     blurRadius: 7,
                            //     offset: const Offset(0, 3),
                            //   ),
                            // ],
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
                              Container(
                                color: Color(int.parse("0xFF130F1D")),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          gameManager.rollDice();
                                          setState(() {});
                                        },
                                        child: Text("Roll dice"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          gameManager.endTurn();
                                          setState(() {});
                                        },
                                        child: Text("End turn"),
                                      ),
                                    ],
                                  ),
                                ),
                              ).inGridArea("content"),
                              jail(gameManager: gameManager).inGridArea('go'),
                              cityRow(index: 0, cities: board.sublist(1, 10))
                                  .inGridArea('city1'),
                              cityColumn(
                                      index: 1, cities: board.sublist(11, 20))
                                  .inGridArea('city2'),
                              cityColumn(index: 3, cities: board.sublist(31))
                                  .inGridArea('city3'),
                              cityRow(index: 2, cities: board.sublist(21, 30))
                                  .inGridArea('city4'),
                              jail().inGridArea('jail'),
                              jail().inGridArea('gotojail'),
                              jail().inGridArea('parking')
                            ],
                          ),
                        ),
                        // ...board.map((city) {
                        //   (int, int) position = getPosition(city.index);
                        //   int x = position.$1;
                        //   int y = position.$2;
                        //   return Builder(
                        //     builder: (context) {
                        //       if (city.type == CellType.property) {
                        //         return Positioned(
                        //           left: ((width - 24) / 2) + width * x - x,
                        //           top: (((width - 24) / 2) + width * y + y),
                        //           child: SizedBox(
                        //             width: 24,
                        //             height: 24,
                        //             child: ClipRRect(
                        //               borderRadius: BorderRadius.circular(20),
                        //               child: Image(
                        //                 image: AssetImage(city.imageName),
                        //               ),
                        //             ),
                        //           ),
                        //         );
                        //       }
                        //       return SizedBox();
                        //     },
                        //   );
                        // }).toList(),
                        ...gameManager.players.map(
                          (player) {
                            double playerDirection =
                                getDirection(player.position);
                            return Builder(
                              builder: (context) {
                                if (player.index !=
                                    gameManager.currentPlayer.index) {
                                  return AnimatedPositioned(
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                    top: ((width - playerSize) / 2) +
                                        width * player.yPosition +
                                        player.yPosition +
                                        10,
                                    left: (width - playerSize) / 2 +
                                        width * player.xPosition +
                                        player.xPosition +
                                        10,
                                    child: Transform.rotate(
                                      angle: playerDirection,
                                      child: playerModel(player.color),
                                    ),
                                  );
                                } else {
                                  return AnimatedPositioned(
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                    top: ((width - playerSize) / 2) +
                                        width * player.yPosition +
                                        player.yPosition,
                                    left: (width - playerSize) / 2 +
                                        width * player.xPosition +
                                        player.xPosition,
                                    child: AnimatedScale(
                                      duration: Duration(milliseconds: 600),
                                      curve: Curves.easeInOut,
                                      scale: 1.4,
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
            )
          ],
        ),
      ),
    );
  }
}

(int, int) getPosition(int index) {
  if (index < 10) {
    return (10, index);
  } else if (index < 20) {
    return (10 - index, 10);
  } else if (index < 30) {
    return (0, 10 - (index - 20));
  } else {
    return (index - 30, 0);
  }
}

Widget jail({GameManager? gameManager}) {
  return BlurryContainer(
    width: width,
    height: height,
    blurStrength: 0,
    image: 'assets/images/jail.png',
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

Widget cityRow({int index = 0, required List<Cell> cities}) {
  bool reverseOrder = index == 2;
  return Row(
    textDirection: reverseOrder ? TextDirection.rtl : TextDirection.ltr,
    children: cities.map((city) {
      int cellIndex = cities.indexOf(city) + (index * 10);

      return Stack(
        children: [
          _buildSquare(0,
              width: width,
              height: height,
              name: city.name,
              image: city.imageName),
        ],
      );
    }).toList(),
  );
}

Widget playerModel(Color playerColor) {
  return Stack(children: [
    Container(
      alignment: Alignment.topCenter,
      height: playerSize,
      width: playerSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: playerColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
          ),
        ],
      ),
    ),
    Positioned(top: 10, left: 3, child: playerEye()),
    Positioned(top: 2, left: 3, child: playerEye()),
  ]);
}

Widget playerEye() {
  return Stack(
    children: [
      Container(
        height: 6,
        width: 6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
      ),
      Positioned(
        top: 1,
        left: 0,
        child: Container(
          height: 3,
          width: 3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black,
          ),
        ),
      ),
    ],
  );
}

Widget cityColumn({int index = 0, required List<Cell> cities}) {
  bool reverseOrder = index == 3;
  double angle = 0;
  if (index == 1) {
    angle = -pi / 2;
  } else if (index == 3) {
    angle = pi / 2;
  }

  return Column(
    verticalDirection:
        reverseOrder ? VerticalDirection.up : VerticalDirection.down,
    textDirection: reverseOrder ? TextDirection.rtl : TextDirection.ltr,
    children: cities.map((city) {
      int cellIndex = cities.indexOf(city) + (index * 10);

      return Transform.rotate(
        angle: angle,
        child: Stack(
          children: [
            Container(
              child: _buildSquare(0,
                  image: city.imageName,
                  width: width,
                  height: height,
                  name: city.name),
            ),
            // if (city.type == CellType.property)
            // Positioned(
            //   left: 10,
            //   top: -10,
            //   child: SizedBox(
            //     width: 20,
            //     height: 20,
            //     child: ClipRRect(
            //       borderRadius: BorderRadius.circular(20),
            //       child: Image(
            //         image: AssetImage(city.imageName),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      );
    }).toList(),
  );
}

Widget _buildSquare(int index,
    {double width = 80, double height = 50, String name = "", String? image}) {
  image ??= 'assets/images/spain.png';
  return Stack(
    children: [
      BlurryContainer(
        width: width,
        height: height,
        blurStrength: 2,
        image: image,
        child: Text(
          name,
          style: TextStyle(
              fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
          softWrap: true,
          overflow: TextOverflow.fade,
        ),
      ),
    ],
  );
}

double getDirection(int position) {
  if (position < 10) {
    return pi;
  } else if (position < 20) {
    return -pi / 2;
  } else if (position < 30) {
    return 2 * pi;
  } else {
    return pi / 2;
  }
}
