import 'package:flutter/material.dart';

class AnimatedVisibility extends StatelessWidget {
  final Widget child;
  final bool visible;

  const AnimatedVisibility(
      {super.key, required this.child, required this.visible});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: visible ? 1 : 0.5,
          child: child),
    );
  }
}
