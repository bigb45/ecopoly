import 'dart:ui';

import 'package:ecopoly/models/cell.dart';
import 'package:ecopoly/models/property.dart';
import 'package:ecopoly/util/board.dart';
import 'package:flutter/material.dart';

const cardWidth = 160.0;
const cardHeight = 200.0;
const flagSize = 60.0;

class CellDetails extends StatelessWidget {
  final int cardIndex;
  final VoidCallback onClose;

  const CellDetails(
      {super.key, required this.cardIndex, required this.onClose});

  @override
  Widget build(BuildContext context) {
    Cell cell = board[cardIndex];

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
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
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
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                    style: const TextStyle(fontSize: 10, color: Colors.white),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: (cell as Property).owner?.color ??
                            Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 6.0),
                        child: Text(
                          cell.owner?.name ?? "Not owned",
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  rent(
                      basePrice: (cell as Property).cost,
                      rent: cell.rent,
                      multiplier: 4),
                ],
              ),
            ),
          ),
          // Positioned(
          //   top: -flagSize / 2,
          //   left: (cardWidth - flagSize) / 2,
          //   child: Container(
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(flagSize),
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.black.withOpacity(0.5),
          //           spreadRadius: 2,
          //           blurRadius: 2,
          //           offset: const Offset(0, 0),
          //         ),
          //       ],
          //     ),
          //     child: ClipRRect(
          //         borderRadius: BorderRadius.circular(flagSize),
          //         child: Image.asset(
          //           cell.imageName,
          //           height: flagSize,
          //           width: flagSize,
          //         )),
          //   ),
          // ),
        ],
      ),
    );
  }
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
          "with FOREST",
          style: TextStyle(fontSize: 10, color: Colors.white),
        ),
        const Spacer(),
        Text("\$${(rent * multiplier * 7).round()}",
            style: const TextStyle(fontSize: 10, color: Colors.white))
      ],
    ),
    Text(
      "Mortgage Value \$${(basePrice * 0.5).round()}",
      style: const TextStyle(
        fontSize: 10,
        color: Colors.white,
      ),
    ),
    Row(
      children: [
        Column(
          children: [
            const Icon(
              Icons.water_drop,
              size: 16,
              color: Colors.white,
            ),
            Text(
              "\$$basePrice",
              style: const TextStyle(
                fontSize: 10,
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
                fontSize: 10,
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
                fontSize: 10,
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
          fontSize: 10,
          color: Colors.white,
        ),
      ),
      const Spacer(),
      Text(
        "\$${(rent * multiplier).round()}",
        style: const TextStyle(fontSize: 10, color: Colors.white),
      ),
    ],
  );
}
