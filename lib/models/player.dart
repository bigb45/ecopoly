import 'package:ecopoly/models/property.dart';

class Player {
  String name;
  int money;
  List<Property> properties = const [];
  int position = 0;
  Player({
    required this.name,
    required this.money,
  });
}
