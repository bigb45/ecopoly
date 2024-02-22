import 'package:flutter/material.dart';

class Dice extends StatefulWidget {
  final int value;
  final bool canRoll;
  const Dice({Key? key, required this.value, required this.canRoll})
      : super(key: key);

  @override
  State<Dice> createState() => _DiceState();
}

class _DiceState extends State<Dice> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: widget.canRoll
                ? Colors.blueAccent
                : Colors.black.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      width: 100,
      height: 100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: _buildDots(widget.value),
        ),
      ),
    );
  }

  Widget _buildDots(int value) {
    List<Widget> dots = [];
    switch (value) {
      case 1:
        dots.add(_buildDot());
        break;
      case 2:
        dots.add(Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildDot(visible: false),
            _buildDot(),
          ],
        ));
        dots.add(const SizedBox(
          height: 20,
          width: 20,
        ));
        dots.add(Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildDot(),
            _buildDot(visible: false),
          ],
        ));
        break;
      case 3:
        dots.add(Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildDot(visible: false),
            _buildDot(),
          ],
        ));
        dots.add(const SizedBox(height: 20));
        dots.add(_buildDot());
        dots.add(const SizedBox(height: 20));
        dots.add(Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildDot(),
            _buildDot(visible: false),
          ],
        ));
        break;
      case 4:
        dots.add(Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildDot(),
            _buildDot(),
          ],
        ));
        dots.add(const SizedBox(
          height: 20,
          width: 20,
        ));
        dots.add(Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildDot(),
            _buildDot(),
          ],
        ));
        break;
      case 5:
        dots.add(Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildDot(),
            _buildDot(),
          ],
        ));
        dots.add(const SizedBox(height: 20));
        dots.add(_buildDot());
        dots.add(const SizedBox(height: 20));
        dots.add(Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildDot(),
            _buildDot(),
          ],
        ));
        break;
      case 6:
        dots.add(Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildDot(),
            _buildDot(),
            _buildDot(),
          ],
        ));
        dots.add(const SizedBox(height: 20, width: 20));
        dots.add(Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildDot(),
            _buildDot(),
            _buildDot(),
          ],
        ));
        break;
      default:
        dots.add(_buildDot());
        break;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: dots,
    );
  }

  Widget _buildDot({bool visible = true}) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: visible ? Colors.black : Colors.transparent,
        shape: BoxShape.circle,
      ),
    );
  }
}
