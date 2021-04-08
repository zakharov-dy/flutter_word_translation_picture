import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:word_translation_picture/models/Word.dart';
import 'package:word_translation_picture/presentation/components/share/FlipAnimation.dart';
import 'package:word_translation_picture/presentation/components/share/TinderLikeSwiper.dart';
import 'package:word_translation_picture/presentation/components/share/CachedNonExceptionImage.dart';

const margin = 30;
const alignments = [
  Alignment(0.0, 0.45),
  Alignment(0.0, 0.3),
  Alignment(0.0, 0.0)
];

class CardsPage extends StatelessWidget {
  static const routeName = '/cards';

  const CardsPage() : super();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - margin * 2;

    final height = MediaQuery.of(context).size.height * 0.5;
    final size = Size(width, height);

    return Cards(
      size: size,
      words: ModalRoute.of(context)?.settings.arguments as List<Word>,
    );
  }
}

class Cards extends StatefulWidget {
  const Cards({required this.size, required this.words}) : super();

  final Size size;
  final List<Word> words;

  @override
  _Cards createState() => _Cards(size: size, words: words);
}

class _Cards extends State<Cards> {
  _Cards({required this.size, required this.words}) : super() {
    cards = words.map(_generateCard).toList();
  }

  int index = 0;

  final Size size;
  final List<Word> words;
  final Alignment defaultFrontCardAlign = Alignment(0.0, 0.0);

  late List<Widget> cards;
  late Alignment frontCardAlign;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.deepPurple,
        appBar: AppBar(
          title: Text('${index + 1} / ${cards.length}'),
          backgroundColor: Colors.indigo,
        ),
        body: Container(
          child: Column(
            children: [
              TinderLikeSwiper(
                cards: cards,
                onSwipe: onSwipe,
                alignments: alignments,
                defaultSize: size,
              ),
            ],
          ),
        ),
      );

  void onSwipe(int newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  Widget _generateCard(Word word) => FlipAnimation(
      key: Key('FlipAnimationWordCard${word.id}]'),
      front: FlipWordCard(
        picture: word.image,
        title: word.ru,
        size: size,
      ),
      back: FlipWordCard(
        picture: word.image,
        title: word.en,
        size: size,
      ));
}

class FlipWordCard extends StatelessWidget {
  const FlipWordCard(
      {Key? key,
      required this.picture,
      required this.title,
      required this.size})
      : super(key: key);

  final String? picture;
  final String title;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: size.height,
        width: size.width,
        child: Card(
            child: PhysicalModel(
                color: Colors.white,
                elevation: 20,
                shadowColor: Colors.deepPurple,
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        child: Center(
                          child: CachedNonExceptionImage(img: picture),
                        ),
                      ),
                      FittedBox(
                        child: Text(title,
                            style: Theme.of(context).textTheme.headline2),
                      ),
                    ],
                  ),
                ))));
  }
}
