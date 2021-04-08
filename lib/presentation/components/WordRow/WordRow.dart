import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:word_translation_picture/blocs/words/words_bloc.dart';
import 'package:word_translation_picture/blocs/words/words_events.dart';

import 'package:word_translation_picture/models/Word.dart';
import 'package:word_translation_picture/presentation/WordPage.dart';
import 'package:word_translation_picture/presentation/components/PickPictureDialog.dart';
import 'package:word_translation_picture/presentation/components/share/CircleImage.dart';
import 'package:word_translation_picture/presentation/components/share/FixHeroTextWrapper.dart';
import 'package:word_translation_picture/presentation/components/types.dart';
import 'package:word_translation_picture/utils/wordToTag.dart';

class WordRow extends StatelessWidget {
  WordRow({
    required Key key,
    required this.word,
    required this.slidableController,
    this.onLongWordPress,
    this.onLongPressEnd,
  }) : super(key: key);

  final Word word;
  final SlidableController slidableController;
  final OnLongWordPressCallback? onLongWordPress;
  final VoidCallback? onLongPressEnd;

  @override
  Widget build(BuildContext context) => Slidable(
          key: Key(word.en),
          controller: slidableController,
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.2,
          child: GestureDetector(
            child: ListTile(
                leading: Hero(
                  child: CircleImage(
                    img: word.image,
                    size: 50,
                  ),
                  tag: wordToImageTag(word),
                ),
                title: Hero(
                  child: FixHeroTextWrapper(Text(word.en)),
                  tag: wordToEngTag(word),
                ),
                subtitle: Hero(
                  child: FixHeroTextWrapper(Text(word.ru)),
                  tag: wordToRuTag(word),
                ),
                onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => WordPage(word: word),
                      ),
                    )),
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
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
              color: Colors.deepOrangeAccent,
              icon: Icons.delete_forever_sharp,
              onTap: () => BlocProvider.of<WordsBloc>(context)
                  .add(WordDeletedEvent(word)),
            ),
            IconSlideAction(
              color: Colors.deepPurple,
              icon: Icons.image_search_outlined,
              onTap: () async {
                final image = await Navigator.push(
                  context,
                  PageRouteBuilder(
                    barrierDismissible: true,
                    opaque: false,
                    pageBuilder: (_, anim1, anim2) => FadeTransition(
                      opacity: anim1,
                      child: PickPictureDialog(eng: word.en),
                    ),
                  ),
                ) as String?;

                if (image != null) {
                  BlocProvider.of<WordsBloc>(context)
                      .add(WordUpdatedEvent(word.copyWith(image: image)));
                }
              },
            ),
          ]);
}
