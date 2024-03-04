import 'package:ecopoly/models/cell.dart';
import 'package:ecopoly/models/property.dart';

class BikeLane extends Property {
  BikeLane(
      {required int cost,
      required int rent,
      required String name,
      required int index,
      required String imageName,
      required int setIndex})
      : super(
            cost: cost,
            rent: rent,
            name: name,
            index: index,
            type: CellType.bikelane,
            imageName: imageName,
            setIndex: setIndex);

  @override
  int calculateRent({int diceValue = 0}) {
    int totalRent;
    int ownedBikeLanes = getNumberOfBikeLanes();
    switch (ownedBikeLanes) {
      case 1:
        totalRent = rent;
        break;
      case 2:
        totalRent = rent * 2;
        break;
      case 3:
        totalRent = rent * 4;
        break;
      case 4:
        totalRent = rent * 8;
        break;
      default:
        totalRent = rent;
    }
    return totalRent;
  }

  int getNumberOfBikeLanes() {
    return owner!.properties
        .where((element) => element.type == CellType.bikelane)
        .length;
  }
}
