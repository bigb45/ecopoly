import 'dart:ui';

import 'package:flutter/material.dart';

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
      decoration: BoxDecoration(
        border: Border.all(
            color: Colors.black,
            width: 1,
            strokeAlign: BorderSide.strokeAlignCenter),
      ),
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
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
