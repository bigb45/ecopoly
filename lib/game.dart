// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, unused_local_variable, avoid_print
import 'dart:ui';

import 'package:ecopoly/game_logic/game_manager.dart';
import 'package:ecopoly/models/cell.dart';
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
        color: Colors.blueGrey,
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
                            border: Border.all(color: Colors.black, width: 1),
                            color: ColorScheme.fromSeed(
                                    seedColor: Colors.deepPurple)
                                .primaryContainer,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: LayoutGrid(
                            areas: '''
                                    go       city1     jail
                                    city2    content   city3
                                    gotojail city4     parking
                                  ''',
                            columnSizes: const [auto, auto, auto],
                            rowSizes: const [auto, auto, auto],
                            columnGap: 0,
                            rowGap: 0,
                            children: [
                              jail(gameManager: gameManager).inGridArea('go'),
                              cityRow(index: 0, cities: board.sublist(1, 11))
                                  .inGridArea('city1'),
                              cityColumn(index: 3).inGridArea('city2'),
                              cityColumn(index: 1).inGridArea('city3'),
                              cityRow(index: 2, cities: []).inGridArea('city4'),
                              Container(
                                color: Colors.blueGrey.shade200,
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

class BlurryContainer extends StatelessWidget {
  final double width;
  final double height;
  final double blurStrength;
  final Widget child;
  final String image;

  const BlurryContainer(
      {super.key,
      required this.width,
      required this.height,
      required this.blurStrength,
      required this.child,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: Colors.black,
            width: 1,
            strokeAlign: BorderSide.strokeAlignCenter),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: Image.asset(
              image,
              width: width,
              height: height,
              fit: BoxFit.cover,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: BackdropFilter(
              filter:
                  ImageFilter.blur(sigmaX: blurStrength, sigmaY: blurStrength),
              child: Container(
                width: width,
                height: height,
                color: Colors.black.withOpacity(0.3),
                child: Center(child: child),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget jail({GameManager? gameManager}) {
  return BlurryContainer(
    width: 40,
    height: 40,
    blurStrength: 0,
    image: 'assets/images/jail.png',
    child: Text(
      'Jail',
      style: TextStyle(fontSize: 18, color: Colors.white),
    ),
  );
}

Widget cityRow({int index = 0, required List<Cell> cities}) {
  if (cities.isEmpty) {
    List<Widget> children = List.generate(
      9,
      (index) {
        return _buildSquare(index, width: height, height: width);
      },
    );
    bool reverseOrder = index == 2;
    return Row(
      textDirection: reverseOrder ? TextDirection.rtl : TextDirection.ltr,
      children: children.map((child) {
        int cellIndex = children.indexOf(child) + (index * 10);

        return Stack(
          children: [
            _buildSquare(0, width: width, height: height),
            Text("${children.indexOf(child) + (index * 10) + 1}")
          ],
        );
      }).toList(),
    );
  } else {
    bool reverseOrder = index == 2;
    return Row(
      textDirection: reverseOrder ? TextDirection.rtl : TextDirection.ltr,
      children: cities.map((city) {
        int cellIndex = cities.indexOf(city) + (index * 10);

        return Stack(
          children: [
            _buildSquare(0, width: width, height: height, name: city.name),
            Text("${cities.indexOf(city) + (index * 10) + 1}"),
          ],
        );
      }).toList(),
    );
  }
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

Widget cityColumn({
  int index = 0,
}) {
  List<Widget> children = List.generate(
    9,
    (index) {
      return _buildSquare(index, width: height, height: width);
    },
  );

  bool reverseOrder = index == 3;

  return Column(
    verticalDirection:
        reverseOrder ? VerticalDirection.up : VerticalDirection.down,
    textDirection: reverseOrder ? TextDirection.rtl : TextDirection.ltr,
    children: children.map((child) {
      int cellIndex = children.indexOf(child) + (index * 10);

      return Stack(
        children: [
          Container(
            child: Transform.rotate(
              angle: -pi / 2,
              child: _buildSquare(0, width: width, height: height),
            ),
          ),
          Text("${children.indexOf(child) + (index * 10) + 1}")
        ],
      );
    }).toList(),
  );
}

Widget _buildSquare(int index,
    {double width = 80, double height = 50, String name = ""}) {
  return BlurryContainer(
    width: width,
    height: height,
    blurStrength: 2,
    image: 'assets/images/spain.png',
    child: Text(
      name,
      style: TextStyle(fontSize: 11, color: Colors.white),
      softWrap: true,
    ),
  );
}
