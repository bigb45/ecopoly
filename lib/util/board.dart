import 'package:ecopoly/models/cell.dart';
import 'package:ecopoly/models/property.dart';

List<Cell> board = [
  Cell(
      name: 'Go',
      imageName: 'assets/images/jail.png',
      index: 0,
      type: CellType.start),
  Property(
      imageName: "assets/images/spain.png",
      name: "Madrid",
      index: 1,
      cost: 100,
      rent: 10,
      type: CellType.property),
  Cell(
      imageName: "assets/images/jail.png",
      name: "Chance",
      index: 2,
      type: CellType.chance),
  Cell(
      imageName: "assets/images/spain.png",
      name: "Barcelona",
      index: 3,
      type: CellType.property),
  Cell(
      imageName: "assets/images/jail.png",
      name: "Income Tax",
      index: 4,
      type: CellType.tax),
  Cell(
      imageName: "assets/images/jail.png",
      name: "Electric Train",
      index: 5,
      type: CellType.railroad),
  Cell(
      imageName: "assets/images/india.png",
      name: "Mumbai",
      index: 6,
      type: CellType.property),
  Cell(
      imageName: "assets/images/jail.png",
      name: "chest",
      index: 7,
      type: CellType.communityChest),
  Cell(
      imageName: "assets/images/india.png",
      name: "Delhi",
      index: 8,
      type: CellType.property),
  Cell(
      imageName: "assets/images/india.png",
      name: "Bangalore",
      index: 9,
      type: CellType.property),
  Cell(
      imageName: "assets/images/jail.png",
      name: "Jail",
      index: 10,
      type: CellType.goToJail),

  // Second row
  Cell(
      imageName: "assets/images/turkey.png",
      name: "Istanbul",
      index: 11,
      type: CellType.property),
  Cell(
      imageName: "assets/images/jail.png",
      name: "Solaris Energy",
      index: 12,
      type: CellType.utility),
  Cell(
      imageName: "assets/images/turkey.png",
      name: "Ankara",
      index: 13,
      type: CellType.property),
  Cell(
      imageName: "assets/images/turkey.png",
      name: "Izmir",
      index: 14,
      type: CellType.property),
  Cell(
      imageName: "assets/images/jail.png",
      name: "Electric Train",
      index: 15,
      type: CellType.railroad),
  Cell(
      imageName: "assets/images/sweden.png",
      name: "Stockholm",
      index: 16,
      type: CellType.property),
  Cell(
      imageName: "assets/images/jail.png",
      name: "chest",
      index: 17,
      type: CellType.communityChest),
  Cell(
      imageName: "assets/images/sweden.png",
      name: "Gothenburg",
      index: 18,
      type: CellType.property),
  Cell(
      imageName: "assets/images/sweden.png",
      name: "Malmo",
      index: 19,
      type: CellType.property),
  Cell(
      imageName: "assets/images/jail.png",
      name: "Free Parking",
      index: 20,
      type: CellType.freeParking),

  // Third row
  Cell(
      imageName: "assets/images/australia.png",
      name: "Sydney",
      index: 21,
      type: CellType.property),
  Cell(
      imageName: "assets/images/jail.png",
      name: "Chance",
      index: 22,
      type: CellType.chance),
  Cell(
      imageName: "assets/images/australia.png",
      name: "Melbourne",
      index: 23,
      type: CellType.property),
  Cell(
      imageName: "assets/images/australia.png",
      name: "Brisbane",
      index: 24,
      type: CellType.property),
  Cell(
      imageName: "assets/images/jail.png",
      name: "Electric Train",
      index: 25,
      type: CellType.railroad),
  Cell(
      imageName: "assets/images/canada.png",
      name: "Toronto",
      index: 26,
      type: CellType.property),
  Cell(
      imageName: "assets/images/canada.png",
      name: "Montreal",
      index: 27,
      type: CellType.property),
  Cell(
      imageName: "assets/images/jail.png",
      name: "HydroVista",
      index: 28,
      type: CellType.utility),
  Cell(
      imageName: "assets/images/canada.png",
      name: "Vancouver",
      index: 29,
      type: CellType.property),
  Cell(
      imageName: "assets/images/jail.png",
      name: "Go to Jail",
      index: 30,
      type: CellType.goToJail),

  // Fourth row
  Cell(
      imageName: "assets/images/usa.png",
      name: "New York",
      index: 31,
      type: CellType.property),
  Cell(
      imageName: "assets/images/jail.png",
      name: "Chance",
      index: 32,
      type: CellType.chance),
  Cell(
      imageName: "assets/images/usa.png",
      name: "Los Angeles",
      index: 33,
      type: CellType.property),
  Cell(
      imageName: "assets/images/usa.png",
      name: "Chicago",
      index: 34,
      type: CellType.property),
  Cell(
      imageName: "assets/images/jail.png",
      name: "Electric Train",
      index: 35,
      type: CellType.railroad),
  Cell(
      imageName: "assets/images/brazil.png",
      name: "chest",
      index: 36,
      type: CellType.communityChest),
  Cell(
      imageName: "assets/images/japan.png",
      name: "Tokyo",
      index: 37,
      type: CellType.property),
  Cell(
      imageName: "assets/images/jail.png",
      name: "Income Tax",
      index: 38,
      type: CellType.tax),
  Cell(
      imageName: "assets/images/japan.png",
      name: "Osaka",
      index: 39,
      type: CellType.property),
];
