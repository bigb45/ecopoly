import 'dart:ui';

import 'package:ecopoly/models/property.dart';

class Player {
  String name;
  int money;
  List<Property> properties = const [];
  int position = 0;
  int index;
  Color color;
  Player({
    required this.name,
    required this.money,
    required this.index,
    required this.color,
  });
}
