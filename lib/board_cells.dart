// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, unused_local_variable, avoid_print

import 'dart:math';

import 'package:ecopoly/game.dart';
import 'package:ecopoly/models/cell.dart';
import 'package:ecopoly/widgets/blurry_container.dart';
import 'package:flutter/material.dart';

class BoardRow extends StatelessWidget {
  final int index;
  final List<Cell> cities;
  final Function(int index) onCityClick;

  const BoardRow(
      {super.key,
      required this.index,
      required this.cities,
      required this.onCityClick});

  @override
  Widget build(BuildContext context) {
    bool reverseOrder = index == 2;

    return Row(
      textDirection: reverseOrder ? TextDirection.rtl : TextDirection.ltr,
      children: cities.map(
        (city) {
          int cellIndex = cities.indexOf(city) + (index * 10);
          Widget? centerChild = switch (city.type) {
            CellType.charity => Image.asset(city.imageName),
            CellType.chance => Image.asset(city.imageName),
            CellType.bikelane => Image.asset(city.imageName),
            CellType.utility => Image.asset(city.imageName),
            CellType.tax => Image.asset(city.imageName),
            CellType.jail => null,
            CellType.goToJail => null,
            CellType.freeParking => null,
            CellType.start => null,
            CellType.property => null,
            CellType.city => null,
          };
          return GestureDetector(
            onTap: () {
              onCityClick(cellIndex + 1);
            },
            child: Container(
              color: Color(int.parse("0xFF130F2D")),
              child: _buildSquare(
                cell: city,
                width: height,
                height: width,
                centerChild: centerChild,
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}

class BoardColumn extends StatelessWidget {
  final int index;
  final List<Cell> cities;
  final Function(int index) onCityClick;

  const BoardColumn(
      {super.key,
      required this.index,
      required this.cities,
      required this.onCityClick});

  @override
  Widget build(BuildContext context) {
    bool reverseOrder = index == 3;
    double angle = 0;
    if (index == 1) {
      angle = -pi / 2;
    } else if (index == 3) {
      angle = pi / 2;
    }
    return Column(
      key: ValueKey(index),
      verticalDirection:
          reverseOrder ? VerticalDirection.up : VerticalDirection.down,
      textDirection: reverseOrder ? TextDirection.rtl : TextDirection.ltr,
      children: cities.map((city) {
        int cellIndex = cities.indexOf(city) + (index * 10);
        Widget? centerChild = switch (city.type) {
          CellType.charity => Image.asset(city.imageName),
          CellType.chance => Image.asset(city.imageName),
          CellType.bikelane => Image.asset(city.imageName),
          CellType.utility => Image.asset(city.imageName),
          CellType.tax => Image.asset(city.imageName),
          CellType.jail => null,
          CellType.goToJail => null,
          CellType.freeParking => null,
          CellType.start => null,
          CellType.property => null,
          CellType.city => null,
        };
        return GestureDetector(
          onTap: () {
            onCityClick(cellIndex + 1);
          },
          child: Transform.rotate(
            angle: 0,
            child: Stack(
              children: [
                Container(
                  // color: Colors.red,
                  child: _buildSquare(
                    cell: city,
                    width: width,
                    height: height,
                    centerChild: centerChild,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

Widget _buildSquare(
    {double width = 80,
    double height = 50,
    required Cell cell,
    Widget? centerChild}) {
  return BlurryContainer(
    width: width,
    height: height,
    blurStrength: 0.2,
    cell: cell,
    centerChild: centerChild,
    child: Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Text(
        cell.name,
        style: TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            height: 1),
        textAlign: TextAlign.center,
        softWrap: true,
        overflow: TextOverflow.fade,
      ),
    ),
  );
}
