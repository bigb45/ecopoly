import 'package:ecopoly/models/cell.dart';
import 'package:ecopoly/models/player.dart';

class Property extends Cell {
  int cost;
  int rent;
  Player? owner;
  Property(
      {required this.cost,
      required this.rent,
      required super.name,
      required super.index,
      required super.type,
      required super.imageName});

  bool buyProperty(Player player) {
    if (player.money < cost) {
      return false;
    } else {
      player.money -= cost;
      player.properties.add(this);
      return true;
    }
  }
}
