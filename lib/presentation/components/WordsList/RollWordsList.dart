import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:word_translation_picture/models/Word.dart';
import 'package:word_translation_picture/presentation/components/WordRow/CheckableWordRow.dart';
import 'package:word_translation_picture/presentation/components/types.dart';

class RollWordsList extends StatelessWidget {
  RollWordsList({
    required Key key,
    required this.words,
    this.onLongWordPress,
    this.onLongPressEnd,
  }) : super(key: key);

  final OnLongWordPressCallback? onLongWordPress;
  final VoidCallback? onLongPressEnd;
  final SlidableController slidableController = SlidableController();
  final List<Word> words;

  @override
  Widget build(BuildContext context) => ListView.builder(
        itemCount: words.length,
        padding: EdgeInsets.only(top: 10),
        itemBuilder: (context, index) => CheckableWordRow(
          slidableController: slidableController,
          onLongWordPress: onLongWordPress,
          onLongPressEnd: onLongPressEnd,
          word: words[index],
          key: Key('WordRowCheckable${words[index].id}'),
        ),
      );
}
