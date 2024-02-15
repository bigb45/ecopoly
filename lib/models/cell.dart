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
  communityChest,
  property,
  railroad,
  utility,
  tax,
  jail,
  goToJail,
  freeParking,
  start,
}
