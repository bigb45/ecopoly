import 'package:ecopoly/models/cell.dart';
import 'package:ecopoly/models/property.dart';

class City extends Property {
  City(
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
            type: CellType.city,
            imageName: imageName,
            setIndex: setIndex);

  @override
  int calculateRent({int diceValue = 0}) {
    int totalRent;
    switch (trees) {
      case 1:
        totalRent = rent;
        break;
      case 2:
        totalRent = rent * 2;
        break;
      case 3:
        totalRent = rent * 3;
        break;
      case 4:
        totalRent = rent * 4;
        break;

      default:
        totalRent = rent;
    }
    return totalRent;
  }
}
