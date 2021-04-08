import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:word_translation_picture/blocs/checkbox_list/checkbox_list_cubit.dart';

import 'package:word_translation_picture/models/Word.dart';
import 'package:word_translation_picture/presentation/components/WordRow/CheckableWordListTile.dart';
import 'package:word_translation_picture/presentation/components/WordRow/WordRow.dart';
import 'package:word_translation_picture/presentation/components/types.dart';

import 'WordRowWrapper.dart';

class CheckableWordRow extends StatelessWidget {
  CheckableWordRow({
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
  Widget build(BuildContext context) => WordRowWrapper(
        child: BlocBuilder<CheckboxListCubit, CheckboxListState?>(
            builder: (context, state) => state is CheckboxListDisabled
                ? WordRow(
                    key: Key('WordRow${word.id}'),
                    word: word,
                    slidableController: slidableController,
                    onLongWordPress: onLongWordPress,
                    onLongPressEnd: onLongPressEnd,
                  )
                : CheckableWordListTile(word: word)),
      );
}
