import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_translation_picture/blocs/words/words_bloc.dart';
import 'package:word_translation_picture/blocs/words/words_events.dart';
import 'package:word_translation_picture/models/Word.dart';
import 'package:word_translation_picture/presentation/components/PickPictureDialog.dart';
import 'package:word_translation_picture/presentation/components/share/CachedNonExceptionImage.dart';
import 'package:word_translation_picture/utils/wordToTag.dart';

enum ActionType { delete, update }

class GridWord extends StatelessWidget {
  final Word word;

  GridWord({
    Key? key,
    required this.word,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final menuKey = new GlobalKey();
    final button = new PopupMenuButton(
      key: menuKey,
      itemBuilder: (BuildContext context) => <PopupMenuItem<ActionType>>[
        PopupMenuItem<ActionType>(
          child: const Text('Change picture'),
          value: ActionType.update,
        ),
        PopupMenuItem<ActionType>(child: const Text('Delete'), value: ActionType.delete),
      ],
      onSelected: (type) => _onSelect(type!, context),
      icon: Icon(Icons.more_vert_outlined),
    );

    final Widget image = Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      clipBehavior: Clip.antiAlias,
      child: Hero(tag: wordToImageTag(word), child: CachedNonExceptionImage(img: word.image)),
    );

    return GridTile(
      footer: Material(
          color: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)),
          ),
          clipBehavior: Clip.antiAlias,
          child: GridTileBar(
            backgroundColor: Colors.black45,
            title: Hero(
              child: _GridTitleText(word.en),
              tag: wordToEngTag(word),
            ),
            subtitle: Hero(
              child: _GridTitleText(word.ru),
              tag: wordToRuTag(word),
            ),
            trailing: button,
          )),
      child: image,
    );
  }

  _onSelect(Object type, BuildContext context) async {
    if (type == ActionType.update) {
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
        BlocProvider.of<WordsBloc>(context).add(WordUpdatedEvent(word.copyWith(image: image)));
      }
    } else if (type == ActionType.delete) {
      BlocProvider.of<WordsBloc>(context).add(WordDeletedEvent(word));
    }
  }
}

class _GridTitleText extends StatelessWidget {
  const _GridTitleText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerStart,
          child: Text(text),
        ));
  }
}
