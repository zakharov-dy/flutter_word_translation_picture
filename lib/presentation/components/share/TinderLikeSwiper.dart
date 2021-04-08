import 'package:flutter/material.dart';
import 'dart:math';

import 'package:word_translation_picture/presentation/components/share/nothing.dart';

typedef GetNextPosition = int Function(int num);
typedef OnSwipe = void Function(int num);

class TinderLikeSwiper extends StatefulWidget {
  const TinderLikeSwiper({
    Key? key,
    required this.defaultSize,
    required this.alignments,
    required this.cards,
    required this.onSwipe,
    this.calculateNext,
    // TODO: calculatePrevious work not right
    // this.calculatePrevious,
  }) : super(key: key);

  final Size defaultSize;
  final List<Alignment> alignments;
  final List<Widget> cards;
  final OnSwipe onSwipe;
  final GetNextPosition? calculateNext;
  // final GetNextPosition? calculatePrevious;

  @override
  _TinderLikeSwiper createState() => _TinderLikeSwiper(
        cards: cards,
        defaultSize: defaultSize,
        alignments: alignments,
        onSwipe: onSwipe,
        calculateNext: calculateNext,
        // calculatePrevious: calculatePrevious
      );
}

class _TinderLikeSwiper extends State<TinderLikeSwiper>
    with TickerProviderStateMixin {
  _TinderLikeSwiper({
    required this.defaultSize,
    required this.cards,
    required this.onSwipe,
    required this.alignments,
    this.calculateNext,
    // this.calculatePrevious,
  }) : super() {
    this.sizes = [
      defaultSize,
      Size(defaultSize.width * 0.8, defaultSize.height * 0.8),
      Size(defaultSize.width * 0.7, defaultSize.height * 0.7)
    ];
  }

  Size defaultSize;
  int index = 0;
  final OnSwipe onSwipe;
  final GetNextPosition? calculateNext;
  // final GetNextPosition? calculatePrevious;
  final List<Widget> cards;
  late Widget front;
  late Widget middle;
  late Widget back;
  late List<Size> sizes;
  List<Alignment> alignments;
  late AnimationController _controller;
  late AnimationController _backOpacityController;

  final Alignment defaultFrontCardAlign = Alignment(0.0, 0.0);
  late Alignment frontCardAlign;
  double frontCardRot = 0.0;

  @override
  void initState() {
    super.initState();

    front = cards[index];
    final secondIndex = _calculateNext(index);
    middle = cards[secondIndex];
    final thirdIndex = _calculateNext(secondIndex);
    back = cards[thirdIndex];

    frontCardAlign = alignments[2];
    _controller =
        AnimationController(duration: Duration(milliseconds: 900), vsync: this);
    _backOpacityController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _controller.addListener(() => setState(() {}));
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        changeCardsOrder();
        animateBackCard();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Stack(
      children: <Widget>[
        backCard(),
        middleCard(),
        frontCard(),
        // Prevent swiping if the cards are animating
        _controller.status != AnimationStatus.forward
            ? SizedBox.expand(
                child: GestureDetector(
                // While dragging the first card
                onPanUpdate: (DragUpdateDetails details) {
                  // Add what the user swiped in the last frame to the alignment of the card
                  setState(() {
                    // 20 is the "speed" at which moves the card
                    frontCardAlign = Alignment(
                        frontCardAlign.x +
                            15 *
                                details.delta.dx /
                                MediaQuery.of(context).size.width,
                        frontCardAlign.y +
                            10 *
                                details.delta.dy /
                                MediaQuery.of(context).size.height);

                    frontCardRot = frontCardAlign.x; // * rotation speed;
                  });
                },
                // When releasing the first card
                onPanEnd: (_) {
                  // If the front card was swiped far enough to count as swiped
                  if (frontCardAlign.x > 3.0 || frontCardAlign.x < -3.0) {
                    animateCards();
                  } else {
                    // Return to the initial rotation and alignment
                    setState(() {
                      frontCardAlign = defaultFrontCardAlign;
                      frontCardRot = 0.0;
                    });
                  }
                },
              ))
            : nothing,
      ],
    ));
  }

  Widget backCard() {
    return Align(
        alignment: _controller.status == AnimationStatus.forward
            ? backCardAlignmentAnim(_controller).value
            : alignments[0],
        child: SizedBox.fromSize(
            size: _controller.status == AnimationStatus.forward
                ? backCardSizeAnim(_controller).value
                : sizes[2],
            child: _backOpacityController.status == AnimationStatus.forward
                ? FadeTransition(
                    opacity: backCardOpacityAnim(_backOpacityController),
                    child: back,
                  )
                : back));
  }

  Widget middleCard() {
    return Align(
      alignment: _controller.status == AnimationStatus.forward
          ? middleCardAlignmentAnim(_controller).value
          : alignments[1],
      child: SizedBox.fromSize(
          size: _controller.status == AnimationStatus.forward
              ? middleCardSizeAnim(_controller).value
              : sizes[1],
          child: middle),
    );
  }

  Widget frontCard() {
    return Align(
        alignment: _controller.status == AnimationStatus.forward
            ? frontCardDisappearAlignmentAnim(_controller, frontCardAlign).value
            : frontCardAlign,
        child: Transform.rotate(
          angle: (pi / 180.0) * frontCardRot,
          child: SizedBox.fromSize(size: defaultSize, child: front),
        ));
  }

  void changeCardsOrder() {
    final isRightSwipe = frontCardAlign.x < 0;
    // final nextFunc = isRightSwipe ? _calculateNext : _calculatePrevious;
    final nextFunc = _calculateNext;
    final newIndex = nextFunc(index);
    onSwipe(newIndex);

    setState(() {
      index = newIndex;
      front = cards[index];
      final secondIndex = nextFunc(index);
      middle = cards[secondIndex];
      final thirdIndex = nextFunc(secondIndex);
      back = cards[thirdIndex];

      frontCardAlign = defaultFrontCardAlign;
      frontCardRot = 0.0;
    });
  }

  void animateCards() {
    _controller.stop();
    _controller.value = 0.0;
    _controller.forward();
  }

  void animateBackCard() {
    _backOpacityController.stop();
    _backOpacityController.value = 0.0;
    _backOpacityController.forward();
  }

  int _calculateNext(int num) => calculateNext == null
      ? (num + 1) >= cards.length
          ? 0
          : num + 1
      : calculateNext!(num);

  // int _calculatePrevious(int num) => calculatePrevious == null
  //     ? (num - 1) < 0
  //         ? cards.length - 1
  //         : num - 1
  //     : calculatePrevious!(num);

  Animation<Alignment> backCardAlignmentAnim(AnimationController parent) {
    return AlignmentTween(begin: alignments[0], end: alignments[1]).animate(
        CurvedAnimation(
            parent: parent, curve: Interval(0.4, 0.7, curve: Curves.easeIn)));
  }

  Animation<Size?> backCardSizeAnim(AnimationController parent) {
    return SizeTween(begin: sizes[2], end: sizes[1]).animate(CurvedAnimation(
        parent: parent, curve: Interval(0.4, 0.7, curve: Curves.easeIn)));
  }

  Animation<double> backCardOpacityAnim(AnimationController parent) {
    return Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: parent, curve: Curves.easeOut));
  }

  Animation<Alignment> middleCardAlignmentAnim(AnimationController parent) {
    return AlignmentTween(begin: alignments[1], end: alignments[2]).animate(
        CurvedAnimation(
            parent: parent, curve: Interval(0.2, 0.5, curve: Curves.easeIn)));
  }

  Animation<Size?> middleCardSizeAnim(AnimationController parent) {
    return SizeTween(begin: sizes[1], end: sizes[0]).animate(CurvedAnimation(
        parent: parent, curve: Interval(0.2, 0.5, curve: Curves.easeIn)));
  }

  Animation<Alignment> frontCardDisappearAlignmentAnim(
      AnimationController parent, Alignment beginAlign) {
    return AlignmentTween(
            begin: beginAlign,
            end: Alignment(
                beginAlign.x > 0 ? beginAlign.x + 30.0 : beginAlign.x - 30.0,
                0.0) // Has swiped to the left or right?
            )
        .animate(CurvedAnimation(
            parent: parent, curve: Interval(0.0, 0.5, curve: Curves.easeIn)));
  }
}
