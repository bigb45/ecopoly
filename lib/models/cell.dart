class Cell {
  String name;
  String imageName;
  int index;
  CellType type;
  Cell(
      {required this.imageName,
      required this.name,
      required this.index,
      required this.type});
}

enum CellType {
  chance,
  charity,
  property,
  bikelane,
  utility,
  tax,
  jail,
  goToJail,
  freeParking,
  start,
}
