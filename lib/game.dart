// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, unused_local_variable, avoid_print

import "dart:math";

import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import 'package:ecopoly/animations/animated_scale_fade.dart';
import 'package:ecopoly/game_logic/game_manager.dart';
import 'package:ecopoly/models/cell.dart';
import 'package:ecopoly/models/player.dart';
import 'package:ecopoly/util/board.dart';
import 'package:ecopoly/widgets/blurry_container.dart';
import 'package:ecopoly/widgets/cell_details.dart';
import 'package:ecopoly/widgets/content_widget.dart';

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
                            ContentWidget(
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
                                  0 => -15,
                                  1 => 15,
                                  2 => -15,
                                  3 => 15,
                                  int() => 0
                                };
                                int xOffset = switch (player.index) {
                                  0 => -12,
                                  1 => 12,
                                  2 => 12,
                                  3 => -12,
                                  int() => 0
                                };
                                int inJailOffset = player.isInJail ? 20 : 0;
                                return AnimatedPositioned(
                                  duration: Duration(milliseconds: 600),
                                  curve: Curves.easeInOut,
                                  top: ((height - playerSize) / 2) +
                                      height * player.yPosition +
                                      player.yPosition +
                                      yOffset +
                                      10,
                                  left: (height - playerSize) / 2 +
                                      height * player.xPosition +
                                      player.xPosition +
                                      xOffset +
                                      10,
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
                                      height * player.yPosition +
                                      player.yPosition,
                                  left: (width - playerSize) / 2 +
                                      height * player.xPosition +
                                      player.xPosition,
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
                  players: gameManager.players,
                  currentPlayerIndex: gameManager.currentPlayer.index,
                  onPlayerClick: (player) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return PlayerPropertiesDialog(
                            gameManager: gameManager, player: player);
                      },
                    );
                  },
                ),
                Visibility(
                  visible: gameManager.gameStarted,
                  child: ElevatedButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AlertDialog(
                          actionsAlignment: MainAxisAlignment.center,
                          content: Text("Are you sure you want to Bankrupt?"),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {});
                                Navigator.pop(context);
                              },
                              child: Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // TODO: replace the index with the actual player's index
                                gameManager
                                    .quit(gameManager.currentPlayer.index);
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
                    child: Text("Bankrupt"),
                  ),
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
      scrollable: true,
      title: Column(
        children: [
          Text('${player.name}\'s Properties'),
          Text(
            "Money: \$${player.money}",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          padding: EdgeInsets.all(16.0),
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
                    SizedBox(width: 8),
                    Text(
                      property.name,
                      style: TextStyle(color: Colors.black),
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
            child: Text("Offer Trade"),
          ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}

class TradeDialog extends StatefulWidget {
  final Player currentPlayer;
  final Player targetPlayer;

  const TradeDialog({
    Key? key,
    required this.currentPlayer,
    required this.targetPlayer,
  }) : super(key: key);

  @override
  State<TradeDialog> createState() => _TradeDialogState();
}

class _TradeDialogState extends State<TradeDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        ElevatedButton(
          onPressed: null,
          child: Text("Offer"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
      ],
      title: Text(
        "Trade Properties",
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PlayerPropertiesList(player: widget.targetPlayer),
                SizedBox(
                  width: 10,
                ),
                PlayerPropertiesList(player: widget.currentPlayer),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerPropertiesList extends StatefulWidget {
  final Player player;

  const PlayerPropertiesList({
    Key? key,
    required this.player,
  }) : super(key: key);

  @override
  State<PlayerPropertiesList> createState() => _PlayerPropertiesListState();
}

class _PlayerPropertiesListState extends State<PlayerPropertiesList> {
  Set<int> selectedIndexes = {};
  int selectedMoney = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Center(
          child: Text(
            widget.player.name,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 8),
        Text("\$$selectedMoney"),
        Slider(
            value: selectedMoney.toDouble(),
            onChanged: (value) {
              setState(() {
                selectedMoney = value.toInt();
              });
            },
            max: widget.player.money.toDouble(),
            min: 0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            widget.player.properties.length,
            (index) {
              final property = widget.player.properties[index];
              final isSelected = selectedIndexes.contains(index);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedIndexes.remove(index);
                    } else {
                      selectedIndexes.add(index);
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? Colors.purpleAccent : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? Colors.purpleAccent : Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.asset(
                          property.imageName,
                          width: 15,
                          height: 15,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        property.name,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
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
            CellType.charity => Image.asset(city.imageName),
            CellType.chance => Image.asset(city.imageName),
            CellType.bikelane => Image.asset(city.imageName),
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
          CellType.charity => Image.asset(city.imageName),
          CellType.chance => Image.asset(city.imageName),
          CellType.bikelane => Image.asset(city.imageName),
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
            spreadRadius: 4,
            blurRadius: 10,
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
