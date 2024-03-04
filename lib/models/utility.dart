import 'package:ecopoly/models/cell.dart';
import 'package:ecopoly/models/property.dart';

class Utility extends Property {
  Utility(
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
            type: CellType.utility,
            imageName: imageName,
            setIndex: setIndex);

  @override
  int calculateRent({int diceValue = 0}) {
    int totalRent;
    int ownedUtilities = getNumberOfUtilities();
    switch (ownedUtilities) {
      case 1:
        totalRent = diceValue * 4;
        break;
      case 2:
        totalRent = diceValue * 10;
        break;
      default:
        totalRent = rent;
    }
    print("utility rent is $totalRent");
    return totalRent;
  }

  int getNumberOfUtilities() {
    return owner!.properties
        .where((element) => element.type == CellType.utility)
        .length;
  }
}
