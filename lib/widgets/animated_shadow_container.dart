import 'package:flutter/material.dart';

class AnimatedShadowContainer extends StatefulWidget {
  final double width;
  final double height;
  final double cellRadius;
  final Color? ownerColor;
  final bool isProperty;
  final Widget? child;

  const AnimatedShadowContainer({
    Key? key, // Corrected key parameter
    required this.width,
    required this.height,
    required this.isProperty,
    required this.cellRadius,
    this.ownerColor,
    this.child, // Added child parameter
  }) : super(key: key); // Corrected super call

  @override
  AnimatedShadowContainerState createState() => AnimatedShadowContainerState();
}

class AnimatedShadowContainerState extends State<AnimatedShadowContainer>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(widget.cellRadius),
        boxShadow: [
          BoxShadow(
            color: widget.isProperty
                ? widget.ownerColor ?? Colors.transparent
                : Colors.transparent,
            spreadRadius: 10,
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: widget.child, // Use the child passed from the widget
    );
  }
}
