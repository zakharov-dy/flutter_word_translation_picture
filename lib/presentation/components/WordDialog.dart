import 'package:flutter/material.dart';
import 'package:word_translation_picture/models/Word.dart';
import 'package:word_translation_picture/presentation/components/share/CachedNonExceptionImage.dart';

class WordDialog extends StatelessWidget {
  WordDialog({Key? key, required this.word}) : super(key: key);

  final Word word;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: PhysicalModel(
            color: Colors.white,
            elevation: 20,
            shadowColor: Colors.deepPurple,
            child: Column(
              children: <Widget>[
                CachedNonExceptionImage(img: word.image),
                ListTile(
                  title: Text(word.en),
                  subtitle: Text(word.ru),
                )
              ],
              mainAxisSize: MainAxisSize.min,
            )));
  }
}
