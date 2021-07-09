import 'package:flutter/material.dart';
import 'package:word_translation_picture/models/Word.dart';
import 'package:word_translation_picture/presentation/WordPage.dart';
import 'package:word_translation_picture/presentation/components/WordsList/GridWord.dart';
import 'package:word_translation_picture/presentation/components/types.dart';

enum ActionType { delete, update }

class GridWordsList extends StatelessWidget {
  GridWordsList({
    required Key key,
    required this.words,
    this.onLongWordPress,
    this.onLongPressEnd,
  }) : super(key: key);

  final List<Word> words;
  final OnLongWordPressCallback? onLongWordPress;
  final VoidCallback? onLongPressEnd;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      restorationId: 'grid_view_demo_grid_offset',
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      padding: const EdgeInsets.all(8),
      childAspectRatio: 1,
      children: words.map<Widget>((word) {
        return _GridPhotoItem(
          word: word,
          key: Key('${word.id}'),
          onLongWordPress: onLongWordPress,
          onLongPressEnd: onLongPressEnd,
        );
      }).toList(),
    );
  }
}

class _GridPhotoItem extends StatelessWidget {
  final OnLongWordPressCallback? onLongWordPress;
  final VoidCallback? onLongPressEnd;
  final Word word;

  _GridPhotoItem({
    required Key key,
    required this.word,
    this.onLongWordPress,
    this.onLongPressEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: GridWord(
        word: word,
        key: new Key("GridWord" + word.id.toString()),
      ),
      onLongPressStart: (LongPressStartDetails details) {
        if (onLongWordPress != null) {
          onLongWordPress!(word);
        }
      },
      onLongPressEnd: (LongPressEndDetails details) {
        if (onLongPressEnd != null) {
          onLongPressEnd!();
        }
      },
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) {
              return WordPage(word: word);
            },
          ),
        );
      },
    );
  }
}
