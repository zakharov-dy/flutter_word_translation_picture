import 'dart:math';

import 'package:flutter/material.dart';

class FlipAnimation extends StatefulWidget {
  FlipAnimation({Key? key, required this.front, required this.back})
      : super(key: key);

  final Widget front;
  final Widget back;

  @override
  _FlipAnimationState createState() =>
      _FlipAnimationState(back: back, front: front);
}

class _FlipAnimationState extends State<FlipAnimation> {
  _FlipAnimationState({required this.front, required this.back}) : super();

  final Widget front;
  final Widget back;

  late bool _showFrontSide;
  late bool _flipXAxis;

  @override
  void initState() {
    super.initState();
    _showFrontSide = true;
    _flipXAxis = true;
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: _switchCard,
        child: StatelessFlipAnimation(
          back: back,
          front: front,
          flipXAxis: _flipXAxis,
          showFrontSide: _showFrontSide,
        ),
      );

  void _switchCard() {
    setState(() {
      _showFrontSide = !_showFrontSide;
    });
  }
}

class StatelessFlipAnimation extends StatelessWidget {
  StatelessFlipAnimation(
      {required this.front,
      required this.back,
      required this.showFrontSide,
      required this.flipXAxis})
      : super();

  final Widget front;
  final Widget back;
  final bool showFrontSide;
  final bool flipXAxis;

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
        duration: Duration(milliseconds: 800),
        transitionBuilder: __transitionBuilder,
        layoutBuilder: (widget, list) => Stack(children: [widget!, ...list]),
        child: showFrontSide ? _buildFront() : _buildRear(),
        switchInCurve: Curves.easeInBack,
        switchOutCurve: Curves.easeInBack.flipped,
      );

  Widget __transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(showFrontSide) != widget!.key);
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= isUnder ? -1.0 : 1.0;
        final value =
            isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
        return Transform(
          transform: flipXAxis
              ? (Matrix4.rotationY(value)..setEntry(3, 0, tilt))
              : (Matrix4.rotationX(value)..setEntry(3, 1, tilt)),
          child: widget,
          alignment: Alignment.center,
        );
      },
    );
  }

  Widget _buildFront() => Container(
        key: ValueKey(true),
        child: front,
      );

  Widget _buildRear() => Container(
        key: ValueKey(false),
        child: back,
      );
}
