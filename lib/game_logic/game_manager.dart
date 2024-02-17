// ignore_for_file: avoid_print

import 'dart:math';

import 'package:ecopoly/models/cell.dart';
import 'package:ecopoly/models/player.dart';
import 'package:ecopoly/util/board.dart';
import 'package:flutter/material.dart';

const gridWidth = 11;

class GameManager {
  static final _instance = GameManager._init();
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
          money: 1500,
          index: index,
          color: Colors.primaries[index]),
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

    currentPlayer.position =
        (currentPlayer.position + (firstDie + secondDie)) % 40;
    print(
        "player ${currentPlayer.name} rolled a $firstDie and $secondDie, now at position ${currentPlayer.position}");
    updatePosition(currentPlayer.xPosition, currentPlayer.yPosition,
        currentPlayer.position);

    if (firstDie == secondDie) {
      rolledDice = false;
      doublesCount++;
    } else {
      rolledDice = true;
      doublesCount = 0;
    }
    if (doublesCount == 3) {
      rolledDice = true;
      doublesCount = 0;
      currentPlayer.position = 10;
      updatePosition(currentPlayer.xPosition, currentPlayer.yPosition, 10);
      print(
          "Player ${currentPlayer.name} rolled doubles 3 times in a row, go to jail");
    }
    CellType cellType = board[currentPlayer.position].type;
    if (cellType == CellType.property ||
        cellType == CellType.utility ||
        cellType == CellType.railroad) {
      canBuyProperty = true;
    } else {
      canBuyProperty = false;
    }

    return (firstDie, secondDie);
  }

  void buyProperty() {
    canBuyProperty = false;
    print(
        "Player ${currentPlayer.name} bought ${board[currentPlayer.position].name}");
  }

  void endTurn() {
    currentPlayer = _nextPlayer();
    rolledDice = false;
    canBuyProperty = false;
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
