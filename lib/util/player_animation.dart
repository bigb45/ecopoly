import 'package:flutter/material.dart';

class AnimatedScale extends StatefulWidget {
  final double scale;
  final Duration duration;
  final Curve curve;
  final Widget child;
  const AnimatedScale(
      {super.key,
      required this.scale,
      required this.duration,
      required this.curve,
      required this.child});

  @override
  State<AnimatedScale> createState() => _AnimatedScaleState();
}

class _AnimatedScaleState extends State<AnimatedScale>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotationAnimation;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _scaleController =
        AnimationController(vsync: this, duration: widget.duration);
    _scaleAnimation = Tween<double>(begin: 1, end: widget.scale).animate(
        CurvedAnimation(parent: _scaleController, curve: widget.curve));

    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _fadeAnimation =
        Tween<double>(begin: 1.0, end: 0.6).animate(_fadeController);

    _rotationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _rotationAnimation =
        Tween<double>(begin: 0, end: 1).animate(_rotationController);

    _fadeController.repeat(reverse: true);
    _scaleController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: RotationTransition(
          turns: _rotationAnimation,
          child: widget.child,
        ),
      ),
    );
  }
}
