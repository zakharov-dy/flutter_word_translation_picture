import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_translation_picture/models/Word.dart';
import 'package:word_translation_picture/presentation/HomePage/words_view_type_cubit.dart';
import 'package:word_translation_picture/presentation/components/WordsList/GridWordsList.dart';
import 'package:word_translation_picture/presentation/components/WordsList/RollWordsList.dart';
import 'package:word_translation_picture/presentation/components/WordsList/AnimatedWordDialog.dart';
import 'package:word_translation_picture/presentation/components/share/FlipAnimation.dart';
import 'package:word_translation_picture/presentation/components/share/nothing.dart';

class WordsList extends StatelessWidget {
  WordsList({Key? key, required this.words, required this.type})
      : super(key: key);

  List<Word> words;
  WordsViewType type;
  final cubit = WordDialogCubit();

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.center,
        children: <Widget>[
          StatelessFlipAnimation(
              front: Container(
                color: Colors.white,
                child: RollWordsList(
                    words: words,
                    onLongPressEnd: cubit.closeDialog,
                    onLongWordPress: cubit.openDialog,
                    key: Key('RollWordsList')),
              ),
              back: Container(
                  color: Colors.white,
                  child: GridWordsList(
                      words: words,
                      onLongPressEnd: cubit.closeDialog,
                      onLongWordPress: cubit.openDialog,
                      key: Key('GridList'))),
              showFrontSide: type == WordsViewType.list,
              flipXAxis: true),
          BlocBuilder<WordDialogCubit, WordDialogCubitState>(
              bloc: cubit,
              builder: (context, state) => state.word == null
                  ? nothing
                  : AnimatedWordDialog(
                      word: state.word!,
                      isShown: state.isShown,
                      key: Key('WordDialog${state.isShown}'))),
        ],
      );
}
