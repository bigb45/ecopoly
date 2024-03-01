import 'dart:ui';

import 'package:ecopoly/models/player_status.dart';
import 'package:ecopoly/models/property.dart';

class Player {
  final String name;
  int money;
  List<Property> properties = [];
  int position = 0;
  int xPosition = 0;
  int yPosition = 0;
  int jailTurns = 0;
  bool isInJail = false;
  PlayerStatus status = PlayerStatus.playing;
  final int index;
  final Color color;
  Player({
    required this.name,
    required this.money,
    required this.index,
    required this.color,
  });
}
