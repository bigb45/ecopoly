import 'package:ecopoly/models/cell.dart';

class Tax extends Cell {
  int? amount;
  double? percentage;
  Tax(
      {required String imageName,
      required String name,
      required int index,
      this.amount,
      this.percentage})
      : super(
          imageName: imageName,
          name: name,
          index: index,
          type: CellType.tax,
        ) {
    assert(amount == null || percentage == null);
  }
}
