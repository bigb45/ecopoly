import 'package:ecopoly/models/property.dart';

class Player {
  String name;
  int money;
  List<Property> properties = const [];
  int position = 0;
  int index;
  Player({
    required this.name,
    required this.money,
    required this.index,
  });
}
