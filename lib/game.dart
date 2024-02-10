// ignore_for_file: avoid_unnecessary_containers

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

const double width = 40;
const double height = 30;

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          color: ColorScheme.fromSeed(seedColor: Colors.deepPurple)
              .primaryContainer,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        height: MediaQuery.of(context).size.height * 0.95,
        width: MediaQuery.of(context).size.width * 0.5,
        // child: SingleChildScrollView(
        //   scrollDirection: Axis.horizontal,
        //   child: SingleChildScrollView(
        child: LayoutGrid(
          areas: '''
          go       city1     jail
          city2    content   city3
          gotojail city4     parking
        ''',
          columnSizes: const [auto, auto, auto],
          rowSizes: const [auto, auto, auto],
          columnGap: 0,
          rowGap: 0,
          children: [
            jail().inGridArea('go'),
            cityRow().inGridArea('city1'),
            cityColumn().inGridArea('city2'),
            cityColumn().inGridArea('city3'),
            cityRow().inGridArea('city4'),
            // jail().inGridArea('content'),
            jail().inGridArea('jail'),
            jail().inGridArea('gotojail'),
            jail().inGridArea('parking')
          ],
        ),
      )),
      //   ),
      // ),
    );
  }
}

class BlurryContainer extends StatelessWidget {
  final double width;
  final double height;
  final double blurStrength;
  final Widget child;
  final String image;

  const BlurryContainer(
      {super.key,
      required this.width,
      required this.height,
      required this.blurStrength,
      required this.child,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: Image.asset(
              image,
              width: width,
              height: height,
              fit: BoxFit.cover,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: BackdropFilter(
              filter:
                  ImageFilter.blur(sigmaX: blurStrength, sigmaY: blurStrength),
              child: Container(
                width: width,
                height: height,
                color: Colors.black.withOpacity(0.3),
                child: Center(child: child),
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget jail() {
  return const BlurryContainer(
    width: 40,
    height: 40,
    blurStrength: 0,
    image: 'assets/images/jail.png',
    child: Text(
      'Jail',
      style: TextStyle(fontSize: 18, color: Colors.white),
    ),
  );
}

Widget cityRow() {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: List.generate(
      9,
      (index) {
        return Expanded(
          child: _buildSquare(index, width: height, height: width),
        );
      },
    ),
  );
}

Widget cityColumn() {
  return Column(
    children: [
      _buildSquare(0, width: width, height: height),
      _buildSquare(1, width: width, height: height),
      _buildSquare(2, width: width, height: height),
      _buildSquare(3, width: width, height: height),
      _buildSquare(4, width: width, height: height),
      _buildSquare(5, width: width, height: height),
      _buildSquare(6, width: width, height: height),
      _buildSquare(7, width: width, height: height),
      _buildSquare(8, width: width, height: height),
    ],
  );
}

Widget _buildSquare(int index, {double width = 80, double height = 50}) {
  return BlurryContainer(
    width: width,
    height: height,
    blurStrength: 2,
    image: 'assets/images/brazil.png',
    child: Text(
      'Barcelona $index',
      style: const TextStyle(fontSize: 12, color: Colors.white),
    ),
  );
}
