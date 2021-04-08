import 'package:flutter/material.dart';
import 'package:word_translation_picture/models/Word.dart';
import 'package:word_translation_picture/presentation/components/share/CachedNonExceptionImage.dart';
import 'package:word_translation_picture/presentation/components/share/FixHeroTextWrapper.dart';
import 'package:word_translation_picture/utils/wordToTag.dart';

class WordPage extends StatelessWidget {
  final Word word;

  WordPage({required this.word});

  Widget build(BuildContext context) {
    TextStyle headline4 = Theme.of(context).textTheme.headline4!;
    TextStyle whiteHeadline4 = headline4.copyWith(color: Colors.white);
    TextStyle headline3 = Theme.of(context).textTheme.headline3!;
    TextStyle whiteHeadline3 = headline3.copyWith(color: Colors.white);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flippers Page'),
        backgroundColor: Colors.indigo,
      ),
      body: Container(
          color: Colors.deepPurple,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: wordToImageTag(word),
                child: CachedNonExceptionImage(img: word.image),
              ),
              Hero(
                  tag: wordToEngTag(word),
                  child: FixHeroTextWrapper(Text(word.en, style: whiteHeadline4))),
              Hero(
                  tag: wordToRuTag(word),
                  child: FixHeroTextWrapper(Text(word.ru, style: whiteHeadline3))),
            ],
          ))),
    );
  }
}