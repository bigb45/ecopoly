// ignore_for_file: avoid_print

import 'dart:math';

import 'package:ecopoly/models/cell.dart';
import 'package:ecopoly/models/player.dart';
import 'package:ecopoly/models/property.dart';
import 'package:ecopoly/models/tax.dart';
import 'package:ecopoly/util/board.dart';
import 'package:flutter/material.dart';

const gridWidth = 11;

class GameManager {
  static final _instance = GameManager._init();
  static const jailPosition = 10;
  static const doublesLimit = 3;
  static const startingMoney = 1000;
  factory GameManager() => _instance;
  bool gameStarted = false;
  bool gameEnded = false;
  bool rolledDice = false;
  bool canBuyProperty = false;
  int doublesCount = 0;
  List<Player> players = const [];
  Player currentPlayer =
      Player(name: '', money: 0, index: -1, color: Colors.blue);

  GameManager._init() {
    players = [];
    currentPlayer = Player(name: '', money: 0, index: -1, color: Colors.blue);
  }

  void setPlayers(int numberOfPlayers) {
    players = List.generate(
      numberOfPlayers,
      (index) => Player(
          name: 'Player ${index + 1}',
          money: startingMoney,
          index: index,
          color: Colors.primaries[3 * index % Colors.primaries.length]),
    );
  }

  void startGame() {
    gameStarted = true;
    currentPlayer = players[0];
    print("Game started");
  }

  (int, int) rollDice() {
    var firstDie = Random().nextInt(6) + 1;
    var secondDie = Random().nextInt(6) + 1;
    // var firstDie = 4;
    // var secondDie = 2;
    int prevPosition = currentPlayer.position;

    currentPlayer.position =
        (currentPlayer.position + (firstDie + secondDie)) % 40;
    print("player ${currentPlayer.name} rolled a $firstDie and $secondDie");
    updatePosition(currentPlayer.xPosition, currentPlayer.yPosition,
        currentPlayer.position);

    if (firstDie == secondDie) {
      rolledDice = false;
      doublesCount++;
    } else {
      rolledDice = true;
      doublesCount = 0;
    }
    if (doublesCount == doublesLimit) {
      rolledDice = true;
      doublesCount = 0;
      currentPlayer.position = jailPosition;
      currentPlayer.isInJail = true;
      updatePosition(currentPlayer.xPosition, currentPlayer.yPosition, 10);
      print(
          "Player ${currentPlayer.name} rolled doubles 3 times in a row, go to jail");
    }
    CellType cellType = board[currentPlayer.position].type;
    _handleNewPlayerPosition(cellType, prevPosition);

    return (firstDie, secondDie);
  }

  void _handleNewPlayerPosition(CellType cellType, int prevPosition) {
    final isProperty = (cellType == CellType.property ||
        cellType == CellType.utility ||
        cellType == CellType.railroad);

    // if the player passes go
    if (prevPosition > currentPlayer.position) {
      currentPlayer.money += 200;
      print("Player ${currentPlayer.name} passed go, received 200");
    }

    // if the player lands on property
    if (isProperty &&
        (board[currentPlayer.position] as Property).owner == null) {
      canBuyProperty = true;
    } else {
      canBuyProperty = false;
    }

    // if the player lands on tax
    if (cellType == CellType.tax) {
      currentPlayer.money -= (board[currentPlayer.position] as Tax).amount ??
          ((board[currentPlayer.position] as Tax).percentage! *
                  currentPlayer.money)
              .round();
      return;
    }

    // if the player lands on property that is owned by another player
    if (isProperty &&
        (board[currentPlayer.position] as Property).owner != null) {
      Property property = board[currentPlayer.position] as Property;
      Player owner = property.owner!;
      if (owner != currentPlayer) {
        currentPlayer.money -= property.rent;
        owner.money += property.rent;
        print(
            "Player ${currentPlayer.name} landed on ${property.name}, paid ${property.rent} to ${owner.name}");
      }
      return;
    }

    // if the player lands on go to jail
    if (cellType == CellType.goToJail) {
      currentPlayer.position = jailPosition;
      updatePosition(
          currentPlayer.xPosition, currentPlayer.yPosition, jailPosition);
      print("Player ${currentPlayer.name} landed on go to jail");
      return;
    }

    // if the player lands on go
    if (cellType == CellType.start) {
      currentPlayer.money += 300;
      print("Player ${currentPlayer.name} landed on go, received 200");
      return;
    }
  }

  void buyProperty() {
    Property property = board[currentPlayer.position] as Property;

    canBuyProperty = false;
    currentPlayer.money -= (board[currentPlayer.position] as Property).cost;
    currentPlayer.properties.add(board[currentPlayer.position] as Property);
    property.owner = currentPlayer;
    List<String> properties = currentPlayer.properties
        .map((property) => property.name)
        .toList()
        .cast<String>();
    print(
        "Player ${currentPlayer.name} bought ${board[currentPlayer.position].name}, ${currentPlayer.name} now has $properties");
  }

  void endTurn() {
    currentPlayer = _nextPlayer();
    rolledDice = false;
    canBuyProperty = false;
    doublesCount = 0;
  }

  Player _nextPlayer() {
    return players[(players.indexOf(currentPlayer) + 1) % players.length];
  }

  void endGame() {
    print("Game ended");
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
    currentPlayer.xPosition = xPosition;
    currentPlayer.yPosition = yPosition;
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
}
