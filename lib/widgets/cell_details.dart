// ignore_for_file: avoid_print

import 'dart:ui';

import 'package:ecopoly/models/cell.dart';
import 'package:ecopoly/models/property.dart';
import 'package:ecopoly/models/tax.dart';
import 'package:ecopoly/util/board.dart';
import 'package:flutter/material.dart';

class CellDetails extends StatelessWidget {
  final int cardIndex;
  final int currentPlayerIndex;
  final VoidCallback onClose;
  final Function(Property) onSell;
  const CellDetails(
      {super.key,
      required this.cardIndex,
      required this.onClose,
      required this.onSell,
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
            propertyInfo(cell,
                currentPlayerIndex: currentPlayerIndex,
                onSell: (Property cell) => onSell(cell as Property)),
          if (cell is Tax) taxInfo(cell),
          if (cell.type == CellType.utility) utilityInfo(cell as Property),
          if (cell.type == CellType.bikelane) bikelaneInfo(cell as Property)
        ],
      ),
    );
  }
}

Widget bikelaneInfo(Property cell) {
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
            ],
          ),
          bikeLaneRent(cell.rent)
        ],
      ),
    ),
  );
}

Widget bikeLaneRent(int rent) {
  return Column(children: [
    bikeRow(1, 25, 1),
    bikeRow(2, 25, 2),
    bikeRow(3, 25, 4),
    bikeRow(4, 25, 8),
  ]);
}

Widget bikeRow(int bikeLanes, int rent, double multiplier) {
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

Widget utilityInfo(Property cell) {
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
            child: Container(
              decoration: BoxDecoration(
                color: (cell).owner?.color ?? Colors.grey.shade900,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 2.0, horizontal: 6.0),
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

Widget propertyInfo(Property cell,
    {required int currentPlayerIndex,
    required Function(Property property) onSell}) {
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
              if (cell.owner != null && cell.owner!.index == currentPlayerIndex)
                ...propertyManagement(
                  onBuild: () {
                    print("Build");
                  },
                  onDestroy: () {
                    print("Destroy");
                  },
                  onSell: () {
                    print("player index $currentPlayerIndex sold ${cell.name}");
                    onSell(cell);
                  },
                )
            ],
          ),
          rent(basePrice: (cell).cost, rent: cell.rent, multiplier: 4),
        ],
      ),
    ),
  );
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

Widget rent(
    {required int basePrice, required int rent, required double multiplier}) {
  return Column(children: [
    rentRow(
      rent,
      multiplier,
      1,
    ),
    rentRow(rent, multiplier * 3, 2),
    rentRow(rent, multiplier * 4, 3),
    rentRow(rent, multiplier * 5, 4),
    Row(
      children: [
        const Text(
          "with Forest",
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
        const Spacer(),
        Text("\$${(rent * multiplier * 7).round()}",
            style: const TextStyle(fontSize: 14, color: Colors.white))
      ],
    ),
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
