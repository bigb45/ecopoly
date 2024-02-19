import 'package:flutter/material.dart';

class AnimatedZoomPan extends StatefulWidget {
  final Widget child;
  final TransformationController transformationController;
  const AnimatedZoomPan(
      {super.key, required this.child, required this.transformationController});

  @override
  State<AnimatedZoomPan> createState() => _AnimatedZoomPanState();
}

class _AnimatedZoomPanState extends State<AnimatedZoomPan>
    with SingleTickerProviderStateMixin {
  late TransformationController _transformationController;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateZoom(double scale) {
    _controller.animateTo(
      scale,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.ease,
    );
  }

  void _animatePan(Offset offset) {
    _controller.animateTo(
      0,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
    _transformationController.value = Matrix4.translationValues(
      offset.dx,
      offset.dy,
      0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return widget.child;
      },
    );
  }
}
