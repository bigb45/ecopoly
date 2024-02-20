// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, unused_local_variable, avoid_print

import 'package:ecopoly/game_logic/game_manager.dart';
import 'package:ecopoly/models/cell.dart';
import 'package:ecopoly/models/property.dart';
import 'package:ecopoly/widgets/blurry_container.dart';
import 'package:ecopoly/util/board.dart';
import 'package:ecopoly/widgets/cell_details.dart';
import 'package:ecopoly/animations/animated_scale_fade.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import "dart:math";

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
  GameManager gameManager = GameManager();
  bool infoCardOpen = false;
  int infoCardIndex = 0;
  @override
  void initState() {
    super.initState();
    gameManager.setPlayers(4);
  }

  void rollDice() {
    gameManager.rollDice();
    double x = gameManager.currentPlayer.xPosition.toDouble();
    double y = gameManager.currentPlayer.yPosition.toDouble();
    // widget.interactiveBoardController.value =
    //     Matrix4.diagonal3Values(1.5, 1.5, 1);
    // widget.interactiveBoardController.value =
    //     widget.interactiveBoardController.value..translate(x * -10, y * -20, 0);
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
        color: Color(int.parse("0xFF130F3D")),
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
                          return Builder(
                            builder: (context) {
                              if (player.index !=
                                  gameManager.currentPlayer.index) {
                                int yOffset = switch (player.index) {
                                  0 => -20,
                                  1 => 20,
                                  2 => -20,
                                  3 => 20,
                                  int() => 0
                                };
                                int xOffset = switch (player.index) {
                                  0 => -15,
                                  1 => 15,
                                  2 => 15,
                                  3 => -15,
                                  int() => 0
                                };
                                int inJailOffset = player.isInJail ? 20 : 0;
                                return AnimatedPositioned(
                                  duration: Duration(milliseconds: 600),
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
                              }
                              // return SizedBox();
                              else {
                                // TODO: place this outside the list in order to place the current player on top of others
                                return AnimatedPositioned(
                                  duration: Duration(milliseconds: 600),
                                  curve: Curves.easeInOutCubic,
                                  top: ((width - playerSize) / 2) +
                                      width * player.yPosition +
                                      player.yPosition,
                                  left: (width - playerSize) / 2 +
                                      width * player.xPosition +
                                      player.xPosition,
                                  child: AnimatedScaleFade(
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
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                PlayersInformation(
                  players: gameManager.players,
                  currentPlayerIndex: gameManager.currentPlayer.index,
                  onPlayerClick: (player) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => (Dialog(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            // add buttons to offer trade
                            child: Column(
                              children: [
                                Text(player.name),
                                Text(player.money.toString()),
                                if (player.index !=
                                    gameManager.currentPlayer.index)
                                  Row(
                                    children: const [
                                      TextButton(
                                        onPressed: null,
                                        child: Text("Offer trade"),
                                      ),
                                    ],
                                  )
                              ],
                            )),
                      )),
                    );
                  },
                ),
                if (gameManager.gameStarted)
                  ElevatedButton(
                      onPressed: () => showDialog(
                            context: context,
                            builder: (BuildContext context) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AlertDialog(
                                actionsAlignment: MainAxisAlignment.center,
                                content:
                                    Text("Are you sure you want to Bankrupt?"),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      // TODO: remove this
                                      gameManager.sendToJail();
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                    child: Text("Cancel"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // TODO: replace the index with the actual player's index
                                      gameManager.quit(
                                          gameManager.currentPlayer.index);
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                    child: Text(
                                      "Bankrupt",
                                      style: TextStyle(
                                          color: ColorScheme.fromSeed(
                                                  seedColor: Colors.deepPurple)
                                              .error),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      child: Text("Bankrupt")),
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
            )
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
                  onPressed: gameManager.currentPlayer.money >= 0
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
                    onPressed: gameManager.currentPlayer.money >=
                            (board[gameManager.currentPlayer.position]
                                    as Property)
                                .cost
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

class BoardRow extends StatelessWidget {
  final int index;
  final List<Cell> cities;
  final Function(int index) onCityClick;

  const BoardRow(
      {super.key,
      required this.index,
      required this.cities,
      required this.onCityClick});

  @override
  Widget build(BuildContext context) {
    bool reverseOrder = index == 2;

    return Row(
      textDirection: reverseOrder ? TextDirection.rtl : TextDirection.ltr,
      children: cities.map(
        (city) {
          int cellIndex = cities.indexOf(city) + (index * 10);
          Widget? centerChild = switch (city.type) {
            CellType.communityChest => Image.asset(city.imageName),
            CellType.chance => Image.asset(city.imageName),
            CellType.railroad => Image.asset(city.imageName),
            CellType.utility => Image.asset(city.imageName),
            CellType.tax => Image.asset(city.imageName),
            CellType.jail => null,
            CellType.goToJail => null,
            CellType.freeParking => null,
            CellType.start => null,
            CellType.property => null,
          };
          return GestureDetector(
            onTap: () {
              onCityClick(cellIndex + 1);
            },
            child: Container(
              child: Stack(
                children: [
                  _buildSquare(
                    cell: city,
                    width: height,
                    height: width,
                    centerChild: centerChild,
                  ),
                ],
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}

class BoardColumn extends StatelessWidget {
  final int index;
  final List<Cell> cities;
  final Function(int index) onCityClick;

  const BoardColumn(
      {super.key,
      required this.index,
      required this.cities,
      required this.onCityClick});

  @override
  Widget build(BuildContext context) {
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
        Widget? centerChild = switch (city.type) {
          CellType.communityChest => Image.asset(city.imageName),
          CellType.chance => Image.asset(city.imageName),
          CellType.railroad => Image.asset(city.imageName),
          CellType.utility => Image.asset(city.imageName),
          CellType.tax => Image.asset(city.imageName),
          CellType.jail => null,
          CellType.goToJail => null,
          CellType.freeParking => null,
          CellType.start => null,
          CellType.property => null,
        };
        return GestureDetector(
          onTap: () {
            onCityClick(cellIndex + 1);
          },
          child: Transform.rotate(
            angle: 0,
            child: Stack(
              children: [
                Container(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _buildSquare(
                        cell: city,
                        width: width,
                        height: height,
                        centerChild: centerChild,
                      ),
                      // uncomment this to show the country flag on the cell
                      // if (city.type == CellType.utility)
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
}

Widget _buildSquare(
    {double width = 80,
    double height = 50,
    required Cell cell,
    Widget? centerChild}) {
  return Stack(
    alignment: Alignment.bottomCenter,
    children: [
      BlurryContainer(
        width: width,
        height: height,
        blurStrength: 0.2,
        cell: cell,
        centerChild: centerChild,
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            cell.name,
            style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                height: 1),
            textAlign: TextAlign.center,
            softWrap: true,
            overflow: TextOverflow.fade,
          ),
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
