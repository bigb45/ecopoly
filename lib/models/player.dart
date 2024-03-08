import 'dart:ui';

import 'package:ecopoly/game.dart';
import 'package:ecopoly/models/player_status.dart';
import 'package:ecopoly/models/property.dart';
import 'package:ecopoly/util/board.dart';
import 'package:ecopoly/util/constants.dart';

class Player {
  static const jailPosition = 10;

  String name;
  int money;
  List<Property> properties = [];
  int position = 0;
  int xPosition = 0;
  int yPosition = 0;
  int jailTurns = 0;
  bool isInJail = false;
  PlayerStatus status = PlayerStatus.playing;
  final int index;
  Color color;
  Player({
    required this.name,
    required this.money,
    required this.index,
    required this.color,
  });

  void buyProperty(Property property) {
    money -= (board[position] as Property).cost;
    properties.add(board[position] as Property);
    property.owner = this;
  }

  void sellProperty(Property property) {
    money += (property.cost * propertySellValue).toInt();
    properties.remove(property);
    property.owner = null;
  }

  void quit() {
    status = PlayerStatus.bankrupt;
    for (var property in properties) {
      property.owner = null;
    }
    properties = [];
  }

  void movePlayer({required int steps}) {
    int targetCell = (position + steps) % 40;
    int distanceToTraverse = steps;

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
    xPosition = xPosition;
    yPosition = yPosition;
  }

  void payRent(int rent) {
    money -= rent;
  }

  void receiveRent(int rent) {
    money += rent;
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

  void goToJail() {
    position = jailPosition;
    isInJail = true;
  }
}
