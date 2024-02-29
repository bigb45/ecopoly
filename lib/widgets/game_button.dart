// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class GameButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String childText;
  final TextStyle? style;
  const GameButton({
    Key? key,
    this.onPressed,
    this.style,
    required this.childText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isActive = onPressed != null;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          isActive
              ? BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 0),
                )
              : const BoxShadow(),
        ],
      ),
      child: Material(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Color(int.parse("0xFF8b5ae3")).withOpacity(isActive ? 1 : 0.8),
        child: InkWell(
          onTap: onPressed != null
              ? () {
                  print("Button Pressed");
                  onPressed!();
                }
              : null,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(childText,
                style: style == null
                    ? TextStyle(
                        color: isActive
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                        fontSize: 16)
                    : style!),
          ),
        ),
      ),
    );
  }
}
