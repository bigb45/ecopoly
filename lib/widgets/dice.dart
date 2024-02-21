import 'dart:async';
import 'dart:math';

import 'package:ecopoly/game_logic/game_manager.dart';
import 'package:flutter/material.dart';

class RollDiceButton extends StatefulWidget {
  final GameManager gameManager;
  const RollDiceButton({super.key, required this.gameManager});

  @override
  _RollDiceButtonState createState() => _RollDiceButtonState();
}

class _RollDiceButtonState extends State<RollDiceButton> {
  late Timer _timer;
  late int _secondDieValue;
  late int _firstDieValue;
  late bool _isRolling;

  @override
  void initState() {
    super.initState();
    _secondDieValue = 1;
    _firstDieValue = 1;
    _isRolling = false;
  }

  void _rollDice() {
    if (!_isRolling) {
      setState(() {
        _isRolling = true;
      });

      _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        setState(() {
          _secondDieValue = Random().nextInt(6) + 1;
          _firstDieValue = Random().nextInt(6) + 1;
        });
      });

      Timer(const Duration(seconds: 1), () {
        _timer.cancel();
        setState(() {
          _isRolling = false;
        });
      });
    }
  }

  @override
  void dispose() {
    // _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _rollDice,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent,
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              width: 100,
              height: 100,
              child: Dice(value: _secondDieValue),
            ),
            const SizedBox(
              width: 20,
            ),
            Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent,
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              width: 100,
              height: 100,
              child: Dice(value: _firstDieValue),
            ),
          ],
        ),
      ),
    );
  }
}

class Dice extends StatelessWidget {
  final int value;

  const Dice({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent,
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
          child: _buildDots(value),
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
