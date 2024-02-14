// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, unused_local_variable, avoid_print

import 'dart:ui';

import 'package:ecopoly/game_logic/game_manager.dart';
import 'package:ecopoly/models/player.dart';
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
  int xPosition = 0;
  int yPosition = 0;
  @override
  void initState() {
    super.initState();
    gameManager.setPlayers(1);
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
                    child: Stack(alignment: Alignment.center, children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          color:
                              ColorScheme.fromSeed(seedColor: Colors.deepPurple)
                                  .primaryContainer,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
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
                            cityRow(gameManager.players,
                                    playerPosition:
                                        gameManager.currentPlayer.index,
                                    index: 0)
                                .inGridArea('city1'),
                            cityColumn(gameManager.players,
                                    playerPosition:
                                        gameManager.currentPlayer.index,
                                    index: 3)
                                .inGridArea('city2'),
                            cityColumn(gameManager.players,
                                    playerPosition:
                                        gameManager.currentPlayer.index,
                                    index: 1)
                                .inGridArea('city3'),
                            cityRow(gameManager.players,
                                    playerPosition:
                                        gameManager.currentPlayer.index,
                                    index: 2)
                                .inGridArea('city4'),
                            Container(
                              color: Colors.blueGrey.shade200,
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    gameManager.rollDice();
                                    (int, int) pos = updatePosition(
                                        xPosition,
                                        yPosition,
                                        gameManager.currentPlayer.position);

                                    setState(() {
                                      print("$xPosition");
                                      xPosition = pos.$1;
                                      print("$xPosition");
                                      yPosition = pos.$2;
                                    });
                                  },
                                  child: Text("Roll dice"),
                                ),
                              ),
                            ).inGridArea("content"),
                            jail().inGridArea('jail'),
                            jail().inGridArea('gotojail'),
                            jail().inGridArea('parking')
                          ],
                        ),
                      ),
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                        top: ((width - playerSize) / 2) +
                            width * yPosition +
                            yPosition,
                        left: (width - playerSize) / 2 +
                            width * xPosition +
                            xPosition,
                        child: playerModel(Colors.black),
                      ),
                    ]),
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

(int, int) updatePosition(int x, int y, int targetCell) {
  int distanceToTraverse = targetCell - getIndex(x, y);
  int xPosition = x;
  int yPosition = y;

  while (distanceToTraverse != 0) {
    if (xPosition == 0 && yPosition < gridWidth - 1) {
      yPosition++;
    } else if (yPosition == gridWidth - 1 && xPosition < gridWidth - 1) {
      xPosition++;
    } else if (xPosition == gridWidth - 1 && yPosition > 0) {
      yPosition--;
    } else if (yPosition == 0 && xPosition > 0) {
      xPosition--;
    }

    distanceToTraverse = targetCell - getIndex(xPosition, yPosition);
  }
  return (xPosition, yPosition);
}

int getIndex(int x, int y) {
  if (y <= x) {
    return x + y;
  } else if (y > x && x != 0) {
    return gridWidth + y + (gridWidth - x - 1) - 1;
  } else if (y > x && x == 0) {
    return (3 * gridWidth - 3) + (gridWidth - y) - 1;
  }
  return 0;
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
              strokeAlign: BorderSide.strokeAlignCenter)),
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
          // Container(
          //   color: Colors.red,
          //   // height: context.of,
          //   child: Text("test", style: TextStyle(color: Colors.white)),
          // )
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

Widget cityRow(List<Player> players, {int playerPosition = -1, int index = 0}) {
  List<Widget> children = List.generate(
    9,
    (index) {
      return _buildSquare(index, width: height, height: width);
    },
  );
  final curentPlayer = players[playerPosition];
  bool reverseOrder = index == 2;
  return Row(
    textDirection: reverseOrder ? TextDirection.rtl : TextDirection.ltr,
    children: children.map((child) {
      int cellIndex = children.indexOf(child) + (index * 10);

      return Stack(
        children: [
          // if (curentPlayer.position == children.indexOf(child) + (index * 10))
          //   Transform.scale(
          //       scaleY: 1,
          //       child: Container(
          //         child: _buildSquare(0, width: width, height: height),
          //       ))
          // else
          _buildSquare(0, width: width, height: height),
          // playerBox(players, curentPlayer, cellIndex, index),
          Text("${children.indexOf(child) + (index * 10) + 1}")
        ],
      );
    }).toList(),
  );
}

Widget playerBox(
    List<Player> players, Player currentPlayer, int cellIndex, int groupIndex) {
  List<Player> playersInCell =
      players.where((player) => player.position == cellIndex).toList();
  int playersInCellCount = playersInCell.length;
  return SizedBox(
    width: width,
    height: height,
    child: Stack(
      clipBehavior: Clip.hardEdge,
      alignment: Alignment.center,
      children: [
        ...playersInCell.asMap().entries.map((entry) {
          int index = entry.key;
          Player player = entry.value;

          double offset = height / 16;
          if (playersInCellCount > 1) {
            offset = (index) * (height / (playersInCellCount + 1));
          }

          if (playersInCellCount == 1) {
            offset = height / 3;
          }

          if (player.index != currentPlayer.index) {
            return Positioned(
              top: offset,
              child: Transform.rotate(
                  angle: -(90 * groupIndex * (pi / 180)),
                  child: playerModel(player.color)),
            );
          }
          return SizedBox();
        }),
        if (currentPlayer.position == cellIndex)
          Center(
            child: AnimatedScale(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              scale: 1.4,
              child: playerModel(currentPlayer.color),
            ),
          ),
      ],
    ),
  );
}

class AnimatedScale extends StatefulWidget {
  final double scale;
  final Duration duration;
  final Curve curve;
  final Widget child;

  const AnimatedScale(
      {super.key,
      required this.scale,
      required this.duration,
      required this.curve,
      required this.child});

  @override
  State<AnimatedScale> createState() => _AnimatedScaleState();
}

class _AnimatedScaleState extends State<AnimatedScale>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController =
        AnimationController(vsync: this, duration: widget.duration);
    _scaleAnimation = Tween<double>(begin: 1, end: widget.scale).animate(
        CurvedAnimation(parent: _scaleController, curve: widget.curve));

    _fadeController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    _fadeAnimation =
        Tween<double>(begin: 1.0, end: 0.6).animate(_fadeController);

    _fadeController.repeat(reverse: true);
    _scaleController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: widget.child,
      ),
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
          )
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

Widget cityColumn(
  List<Player> players, {
  int playerPosition = -1,
  int index = 0,
}) {
  List<Widget> children = List.generate(
    9,
    (index) {
      return _buildSquare(index, width: height, height: width);
    },
  );

  bool reverseOrder = index == 3;
  final curentPlayer = players[playerPosition];

  return Column(
    verticalDirection:
        reverseOrder ? VerticalDirection.up : VerticalDirection.down,
    textDirection: reverseOrder ? TextDirection.rtl : TextDirection.ltr,
    children: children.map((child) {
      int cellIndex = children.indexOf(child) + (index * 10);

      return Stack(
        children: [
          if (curentPlayer.position == children.indexOf(child) + (index * 10))
            Transform.scale(
              scaleX: 1,
              child: Container(
                child: Transform.rotate(
                  angle: -pi / 2,
                  child: _buildSquare(0, width: width, height: height),
                ),
              ),
            )
          else
            Container(
              child: Transform.rotate(
                angle: -pi / 2,
                child: _buildSquare(0, width: width, height: height),
              ),
            ),
          // playerBox(players, curentPlayer, cellIndex, index),
          Text("${children.indexOf(child) + (index * 10) + 1}")
        ],
      );
    }).toList(),
  );
}

Widget _buildSquare(int index, {double width = 80, double height = 50}) {
  return BlurryContainer(
      width: width,
      height: height,
      blurStrength: 2,
      image: 'assets/images/brazil.png',
      child: SizedBox());
}
