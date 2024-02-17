import 'package:ecopoly/models/cell.dart';
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 6,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -5,
            right: -5,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: onClose,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: flagSize / 2 + 4),
            child: Center(
              child: Column(
                children: [
                  Text(cell.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ),
          ),
          Positioned(
            top: -flagSize / 2,
            left: (cardWidth - flagSize) / 2,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(flagSize),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(flagSize),
                  child: Image.asset(
                    cell.imageName,
                    height: flagSize,
                    width: flagSize,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
