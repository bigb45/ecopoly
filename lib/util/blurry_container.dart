import 'dart:ui';

import 'package:flutter/material.dart';

class BlurryContainer extends StatelessWidget {
  final double width;
  final double height;
  final double blurStrength;
  final String image;
  final int? price;

  final Widget child;
  final Widget? centerChild;

  const BlurryContainer(
      {super.key,
      required this.width,
      required this.height,
      required this.blurStrength,
      required this.child,
      required this.image,
      this.centerChild,
      required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.5),
        //     spreadRadius: 2,
        //     blurRadius: 2,
        //     offset: const Offset(0, 0),
        //   ),
        // ],
        border: Border.all(
            color: Colors.black,
            width: 1,
            strokeAlign: BorderSide.strokeAlignCenter),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
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
                color: Colors.black.withOpacity(0.4),
                child: centerChild ?? Container(),
              ),
            ),
          ),
          if (price != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(5),
                ),
                // height: 10,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Text(
                    "\$$price",
                    style: const TextStyle(color: Colors.white, fontSize: 9),
                  ),
                ),
              ),
            ),
          SizedBox(height: height, width: width, child: child),
        ],
      ),
    );
  }
}
