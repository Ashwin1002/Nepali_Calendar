import 'package:flutter/material.dart';

class TapBouncer extends StatefulWidget {
  const TapBouncer({
    Key? key,
    required this.onTap,
    required this.child,
    this.upperBound = .3,
    this.duration,
    this.toolTip = '',
  })  : assert(upperBound >= 0 && upperBound <= 1),
        super(key: key);

  final VoidCallback? onTap;
  final Widget child;
  final double upperBound;
  final Duration? duration;
  final String toolTip;

  @override
  State<TapBouncer> createState() => _TapBouncerState();
}

class _TapBouncerState extends State<TapBouncer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration ?? kThemeAnimationDuration,
      lowerBound: 0.0,
      upperBound: widget.upperBound,
    );
  }

  late double _scale;

  @override
  void dispose() {
    ///remove the listener
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        _scale = 1 - _animationController.value;
        return Transform.scale(
          scale: _scale,
          child: child!,
        );
      },
      child: GestureDetector(
        onTap: () async {
          await _animationController.forward();

          await _animationController.reverse();
          Future.delayed(
            const Duration(milliseconds: 100),
            () {
              if (widget.onTap != null) {
                widget.onTap!();
              }
              // FocusScope.of(context).unfocus();
            },
          );
        },
        child: Tooltip(
          message: widget.toolTip,
          child: widget.child,
        ),
      ),
    );
  }
}
