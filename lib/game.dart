// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'dart:ui';

import 'package:ecopoly/game_logic/game_manager.dart';
import 'package:ecopoly/models/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import "dart:math";

const double width = 40;
const double height = 40;

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
    gameManager.setPlayers(2);
    gameManager.startGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Row(
          children: [
            Center(
              child: Transform.scale(
                scale: 1,
                child: Transform.translate(
                  offset: Offset(0, 0),
                  child: FittedBox(
                    child: Container(
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
                          TextButton(
                            onPressed: () {
                              gameManager.rollDice();
                              setState(() {});
                            },
                            child: Text("Roll dice"),
                          ).inGridArea("content"),
                          jail().inGridArea('jail'),
                          jail().inGridArea('gotojail'),
                          jail().inGridArea('parking')
                        ],
                      ),
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
      decoration:
          BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
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
      return Stack(
        children: [
          if (curentPlayer.position == children.indexOf(child) + (index * 10))
            Transform.scale(
                scaleY: 1.3,
                child: Container(
                  child: _buildSquare(0, width: width, height: height),
                ))
          else
            Container(
              child: _buildSquare(0, width: width, height: height),
            ),
          ...players.map((player) {
            if (player.position == children.indexOf(child) + (index * 10)) {
              return Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Row(children: [
                    // Icon(Icons.face, color: Colors.blue),
                    Text(
                      player.name,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    )
                  ]),
                ),
              );
            }
            return SizedBox();
          })
        ],
      );
    }).toList(),
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
      return Stack(
        children: [
          // scale the patch that the player is on
          if (curentPlayer.position == children.indexOf(child) + (index * 10))
            Transform.scale(
              scaleX: 1.3,
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
          // if (curentPlayer.position == children.indexOf(child) + (index * 10))
          //   Positioned.fill(
          //     child: Align(
          //       alignment: Alignment.center,
          //       child: Row(children: [
          //         // Icon(Icons.face, color: Colors.blue),
          //         Text(
          //           curentPlayer.name,
          //           style: TextStyle(color: Colors.white, fontSize: 12),
          //         )
          //       ]),
          //     ),
          //   )

          ...players.map((player) {
            if (player.position == children.indexOf(child) + (index * 10)) {
              return Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Row(children: [
                    // Icon(Icons.face, color: Colors.blue),
                    Text(
                      player.name,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    )
                  ]),
                ),
              );
            }
            return SizedBox();
          })
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
      child: SizedBox()
      // Text(
      //   'Test $index',
      //   style: const TextStyle(fontSize: 10, color: Colors.white),
      // ),
      );
}
