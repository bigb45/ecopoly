// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, unused_local_variable, avoid_print

import 'package:ecopoly/game_logic/game_manager.dart';
import 'package:ecopoly/models/cell.dart';
import 'package:ecopoly/util/blurry_container.dart';
import 'package:ecopoly/util/board.dart';
import 'package:ecopoly/util/cell_details.dart';
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
  bool infoCardOpen = false;
  int infoCardIndex = 0;
  @override
  void initState() {
    super.initState();
    gameManager.setPlayers(2);
  }

  void rollDice() {
    gameManager.rollDice();
    setState(() {});
  }

  void endTurn() {
    gameManager.endTurn();
    setState(() {});
  }

  void buyProperty() {
    gameManager.buyProperty();
    setState(() {});
  }

  void startGame() {
    gameManager.startGame();
    setState(() {});
  }

  void onCityClick(int index) {
    print("open card ${board[index].name}");

    setState(() {
      infoCardOpen = true;
      infoCardIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(int.parse("0xFF130F1D")),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 80.0, right: 20.0),
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
                            content(
                              gameManager: gameManager,
                              rollDice: rollDice,
                              endTurn: endTurn,
                              buyProperty: buyProperty,
                              startGame: startGame,
                            ).inGridArea("content"),
                            jail(gameManager: gameManager).inGridArea('go'),
                            cityRow(
                                index: 0,
                                cities: board.sublist(1, 10),
                                onCityClick: ((index) =>
                                    onCityClick(index))).inGridArea('city1'),
                            cityColumn(
                                index: 1,
                                cities: board.sublist(11, 20),
                                onCityClick: ((index) =>
                                    onCityClick(index))).inGridArea('city2'),
                            cityRow(
                                index: 2,
                                cities: board.sublist(21, 30),
                                onCityClick: ((index) =>
                                    onCityClick(index))).inGridArea('city4'),
                            cityColumn(
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
                          return Builder(
                            builder: (context) {
                              if (player.index !=
                                  gameManager.currentPlayer.index) {
                                // TODO: make this based on the number of players in the cell instead of absolute index
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
                                return AnimatedPositioned(
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                  top: ((width - playerSize) / 2) +
                                      width * player.yPosition +
                                      player.yPosition +
                                      yOffset,
                                  left: (width - playerSize) / 2 +
                                      width * player.xPosition +
                                      player.xPosition +
                                      xOffset,
                                  child: Transform.rotate(
                                    angle: playerDirection,
                                    child: playerModel(player.color),
                                  ),
                                );
                              } else {
                                // TODO: place this outside the list in order to place the current player on top of others
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
                                    scale: 1.3,
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
            if (infoCardOpen)
              CellDetails(
                cardIndex: infoCardIndex,
                onClose: () {
                  setState(() {
                    infoCardOpen = false;
                    print("closed");
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}

Widget content({
  required GameManager gameManager,
  required VoidCallback rollDice,
  required VoidCallback endTurn,
  required VoidCallback buyProperty,
  required VoidCallback startGame,
}) {
  return Container(
    color: Color(int.parse("0xFF130F1D")),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!gameManager.gameStarted)
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () {
                    startGame();
                  },
                  child: Text("Start game"),
                ),
              if (gameManager.gameStarted && !gameManager.rolledDice)
                AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  opacity: gameManager.rolledDice ? 0 : 1,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    onPressed: !gameManager.rolledDice
                        ? () {
                            rollDice();
                          }
                        : null,
                    child: Text("Roll dice"),
                  ),
                ),
              if (gameManager.rolledDice)
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: gameManager.rolledDice
                      ? () {
                          endTurn();
                        }
                      : null,
                  child: Text("End turn"),
                ),
              if (gameManager.canBuyProperty)
                SizedBox(
                  width: 20,
                ),
              if (gameManager.canBuyProperty)
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    onPressed: gameManager.canBuyProperty
                        ? () {
                            buyProperty();
                          }
                        : null,
                    child: Text("Buy Property"))
            ],
          ),
        ],
      ),
    ),
  );
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
    price: null,
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

Widget cityRow({
  int index = 0,
  required List<Cell> cities,
  required Function(int index) onCityClick,
}) {
  bool reverseOrder = index == 2;

  return Row(
    textDirection: reverseOrder ? TextDirection.rtl : TextDirection.ltr,
    children: cities.map(
      (city) {
        int cellIndex = cities.indexOf(city) + (index * 10);

        return GestureDetector(
          onTap: () {
            onCityClick(cellIndex + 1);
          },
          child: Container(
            child: Stack(
              children: [
                _buildSquare(
                  0,
                  width: width,
                  height: height,
                  price: 130,
                  name: city.name,
                  image: city.imageName,
                ),
              ],
            ),
          ),
        );
      },
    ).toList(),
  );
}

Widget cityColumn(
    {int index = 0,
    required List<Cell> cities,
    required Function(int index) onCityClick}) {
  bool reverseOrder = index == 3;
  double angle = 0;
  if (index == 1) {
    angle = -pi / 2;
  } else if (index == 3) {
    angle = pi / 2;
  }

  return Column(
    key: ValueKey(index),
    verticalDirection:
        reverseOrder ? VerticalDirection.up : VerticalDirection.down,
    textDirection: reverseOrder ? TextDirection.rtl : TextDirection.ltr,
    children: cities.map((city) {
      int cellIndex = cities.indexOf(city) + (index * 10);
      // int? price =
      //     city.type == CellType.property ? (city as Property).cost : null;
      return GestureDetector(
        onTap: () {
          onCityClick(cellIndex + 1);
        },
        child: Transform.rotate(
          angle: angle,
          child: Stack(
            children: [
              Container(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _buildSquare(0,
                        price: 200,
                        image: city.imageName,
                        width: width,
                        height: height,
                        name: city.name),
                    // uncomment this to show the country flag on the cell
                    // if (city.type == CellType.property)
                    //   Positioned(
                    //     top: -10,
                    //     left: 10,
                    //     child: SizedBox(
                    //       width: 24,
                    //       height: 24,
                    //       child: ClipRRect(
                    //         borderRadius: BorderRadius.circular(20),
                    //         child: Image(
                    //           image: AssetImage(city.imageName),
                    //         ),
                    //       ),
                    //     ),
                    //   )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList(),
  );
}

Widget _buildSquare(int index,
    {double width = 80,
    double height = 50,
    String name = "",
    String? image,
    int? price}) {
  image ??= 'assets/images/spain.png';
  return Stack(
    alignment: Alignment.bottomCenter,
    children: [
      BlurryContainer(
        width: width,
        height: height,
        blurStrength: 2,
        image: image,
        price: price,
        child: Text(
          name,
          style: TextStyle(
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              height: 1),
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
