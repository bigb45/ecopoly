// ignore_for_file: avoid_print

import 'dart:ui';

import 'package:ecopoly/game_logic/game_manager.dart';
import 'package:ecopoly/models/cell.dart';
import 'package:ecopoly/models/city.dart';
import 'package:ecopoly/models/property.dart';
import 'package:ecopoly/models/tax.dart';
import 'package:ecopoly/util/board.dart';
import 'package:ecopoly/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CellDetails extends StatelessWidget {
  final int cardIndex;
  final int currentPlayerIndex;
  final VoidCallback onClose;
  const CellDetails(
      {super.key,
      required this.cardIndex,
      required this.onClose,
      required this.currentPlayerIndex});

  @override
  Widget build(BuildContext context) {
    Cell cell = board[cardIndex];
    final cardWidth = MediaQuery.of(context).size.width * 0.4;
    final cardHeight = MediaQuery.of(context).size.height * 0.6;
    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              cell.imageName,
              width: cardWidth,
              height: cardHeight,
              fit: BoxFit.cover,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                width: cardWidth,
                height: cardHeight,
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
          Positioned(
            top: -5,
            right: -5,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 16,
              ),
              onPressed: onClose,
            ),
          ),
          if (cell.type == CellType.charity || cell.type == CellType.chance)
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      cell.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      cell.type.name.toUpperCase(),
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    if (cell.type == CellType.charity)
                      const Text(
                        "Draw a card from the Community Chest",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    if (cell.type == CellType.chance)
                      const Text(
                        "Draw a card from the Chance",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          if (cell is Property &&
              (cell.type != CellType.bikelane && cell.type != CellType.utility))
            PropertyInfo(currentPlayerIndex: currentPlayerIndex, cell: cell),
          if (cell is Tax) taxInfo(cell),
          if (cell.type == CellType.utility)
            UtilityInfo(
              cell: cell as Property,
              currentPlayerIndex: currentPlayerIndex,
            ),
          if (cell.type == CellType.bikelane)
            BikeInfo(
              cell: cell as Property,
              currentPlayerIndex: currentPlayerIndex,
            ),
        ],
      ),
    );
  }
}

class BikeInfo extends StatelessWidget {
  final Property cell;
  final int currentPlayerIndex;
  const BikeInfo(
      {super.key, required this.cell, required this.currentPlayerIndex});

  @override
  Widget build(BuildContext context) {
    final GameManager gameManager =
        Provider.of<GameManager>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              cell.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              cell.type.name.toUpperCase(),
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: (cell).owner?.color ?? Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 6.0),
                      child: Text(
                        cell.owner?.name ?? "Not owned",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                if (cell.owner != null &&
                    cell.owner!.index == currentPlayerIndex)
                  GestureDetector(
                    onTap: () {
                      gameManager.sellProperty(cell);
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: const Offset(0, 0),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child:
                          const Icon(Icons.sell, color: Colors.white, size: 16),
                    ),
                  ),
              ],
            ),
            bikeLaneRent(cell.rent)
          ],
        ),
      ),
    );
  }
}

Widget bikeLaneRent(int rent) {
  return Column(children: [
    bikeInfoRow(1, 25, 1),
    bikeInfoRow(2, 25, 2),
    bikeInfoRow(3, 25, 4),
    bikeInfoRow(4, 25, 8),
  ]);
}

Widget bikeInfoRow(int bikeLanes, int rent, double multiplier) {
  return Row(
    children: [
      Text(
        bikeLanes > 1
            ? "With $bikeLanes Bike lanes"
            : "With $bikeLanes Bike lane",
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
        ),
      ),
      const Spacer(),
      Text(
        "\$${(rent * multiplier).round()}",
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
    ],
  );
}

class UtilityInfo extends StatelessWidget {
  final Property cell;
  final int currentPlayerIndex;
  const UtilityInfo(
      {super.key, required this.cell, required this.currentPlayerIndex});

  @override
  Widget build(BuildContext context) {
    final GameManager gameManager =
        Provider.of<GameManager>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              cell.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              cell.type.name.toUpperCase(),
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: (cell).owner?.color ?? Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 6.0),
                      child: Text(
                        cell.owner?.name ?? "Not owned",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  if (cell.owner != null &&
                      cell.owner!.index == currentPlayerIndex)
                    GestureDetector(
                      onTap: () {
                        gameManager.sellProperty(cell);
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(0, 0),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Icon(Icons.sell,
                            color: Colors.white, size: 16),
                      ),
                    ),
                ],
              ),
            ),
            const Text(
              "If one Utility is owned, rent is 4x the dice roll, if both Utilities are owned, rent is 4x the dice roll",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget taxInfo(Tax cell) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            cell.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            cell.type.name.toUpperCase(),
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
          if (cell.amount != null)
            Text(
              "Pay \$${cell.amount} Environmental Tax",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          if (cell.percentage != null)
            Text(
              "Pay %${((cell.percentage!) * 100)} of the total money you have as Tax",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
        ],
      ),
    ),
  );
}

class PropertyInfo extends StatelessWidget {
  final int currentPlayerIndex;
  final Property cell;
  const PropertyInfo(
      {super.key, required this.currentPlayerIndex, required this.cell});

  @override
  Widget build(BuildContext context) {
    final GameManager gameManager =
        Provider.of<GameManager>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              cell.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              cell.type.name.toUpperCase(),
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: (cell).owner?.color ?? Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 6.0),
                      child: Text(
                        cell.owner?.name ?? "Not owned",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                if (cell.owner != null &&
                    cell.owner!.index == currentPlayerIndex)
                  ...propertyManagement(
                    onBuild: () {
                      gameManager.plantTree(cell as City);
                      print("Build");
                    },
                    onDestroy: () {
                      gameManager.destroyTree(cell as City);
                      print("Destroy");
                    },
                    onSell: () {
                      gameManager.sellProperty(cell);
                    },
                  )
              ],
            ),
            rent(basePrice: (cell).cost, rent: cell.rent),
          ],
        ),
      ),
    );
  }
}

List<Widget> propertyManagement(
    {required VoidCallback onBuild,
    required VoidCallback onDestroy,
    required VoidCallback onSell}) {
  return [
    GestureDetector(
      onTap: onBuild,
      child: Container(
        height: 24,
        width: 24,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 0),
            ),
          ],
          color: Colors.green,
          borderRadius: BorderRadius.circular(100),
        ),
        child: const Icon(
          Icons.arrow_upward,
          color: Colors.white,
          size: 16,
        ),
      ),
    ),
    GestureDetector(
      onTap: onDestroy,
      child: Container(
        height: 24,
        width: 24,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 0),
            ),
          ],
          color: Colors.red,
          borderRadius: BorderRadius.circular(100),
        ),
        child: const Icon(Icons.arrow_downward, color: Colors.white, size: 16),
      ),
    ),
    GestureDetector(
      onTap: onSell,
      child: Container(
        height: 24,
        width: 24,
        decoration: BoxDecoration(
          color: Colors.red,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 0),
            ),
          ],
          borderRadius: BorderRadius.circular(100),
        ),
        child: const Icon(Icons.sell, color: Colors.white, size: 16),
      ),
    ),
  ];
}

Widget rent({required int basePrice, required int rent}) {
  return Column(children: [
    rentRow(rent, rentMultiplier, 1),
    rentRow(rent, rentMultiplier * 3, 2),
    rentRow(rent, rentMultiplier * 6, 3),
    rentRow(rent, rentMultiplier * 10, 4),
    Text(
      "Sell Value \$${(basePrice * 0.8).round()}",
      style: const TextStyle(
        fontSize: 14,
        color: Colors.white,
      ),
    ),
    Row(
      children: [
        Column(
          children: [
            const Icon(
              Icons.monetization_on_rounded,
              size: 16,
              color: Colors.white,
            ),
            Text(
              "\$$basePrice",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const Spacer(),
        Column(
          children: [
            const Icon(
              Icons.park,
              size: 16,
              color: Colors.white,
            ),
            Text(
              "\$${(basePrice * 0.5).round()}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const Spacer(),
        Column(
          children: [
            const Icon(
              Icons.forest,
              size: 16,
              color: Colors.white,
            ),
            Text(
              "\$${(basePrice * 0.5).round()}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    )
  ]);
}

Widget rentRow(rent, multiplier, trees) {
  return Row(
    children: [
      Text(
        trees > 1 ? "With $trees Trees" : "With $trees Tree",
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
        ),
      ),
      const Spacer(),
      Text(
        "\$${(rent * multiplier).round()}",
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
    ],
  );
}
