import 'package:ecopoly/models/cell.dart';
import 'package:ecopoly/models/player.dart';

class Property extends Cell {
  final int cost;
  final int rent;
  final int setIndex;
  final int trees = 0;
  final int forest = 0;
  Player? owner;
  Property(
      {required this.cost,
      required this.rent,
      required super.name,
      required super.index,
      required super.type,
      required super.imageName,
      required this.setIndex});

  int calculateRent({int diceValue = 0}) {
    return rent;
  }
}
