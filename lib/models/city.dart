import 'package:ecopoly/models/cell.dart';
import 'package:ecopoly/models/property.dart';
import 'package:ecopoly/util/board.dart';
import 'package:ecopoly/util/constants.dart';

class City extends Property {
  bool canPlantTree = false;
  bool canDestroyTree = false;
  int treeCost;
  City({
    required int cost,
    required int rent,
    required String name,
    required int index,
    required String imageName,
    required int setIndex,
    required this.treeCost,
  }) : super(
            cost: cost,
            rent: rent,
            name: name,
            index: index,
            type: CellType.city,
            imageName: imageName,
            setIndex: setIndex);

  @override
  int calculateRent({int diceValue = 0}) {
    int totalRent;
    switch (trees) {
      case 1:
        totalRent = rent * rentMultiplier;
        break;
      case 2:
        totalRent = rent * 3 * rentMultiplier;
        break;
      case 3:
        totalRent = rent * 6 * rentMultiplier;
        break;
      case 4:
        totalRent = rent * 10 * rentMultiplier;
        break;

      default:
        totalRent = rent;
    }
    return totalRent;
  }
}

List<Property> getSetProperties(int setIndex) {
  List<Property> properties = board.whereType<Property>().toList();
  return properties.where((property) => property.setIndex == setIndex).toList();
}
