import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_translation_picture/blocs/checkbox_list/checkbox_list_cubit.dart';

import 'package:word_translation_picture/presentation/components/share/CircleImage.dart';
import 'package:word_translation_picture/models/Word.dart';
import 'package:word_translation_picture/presentation/components/share/FixHeroTextWrapper.dart';
import 'package:word_translation_picture/utils/wordToTag.dart';

class CheckableWordListTile extends StatelessWidget {
  CheckableWordListTile({
    Key? key,
    required this.word,
  }) : super(key: key);

  final Word word;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<CheckboxListCubit, CheckboxListState?>(
          builder: (context, state) => CheckboxListTile(
                secondary: Hero(
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
                onChanged: (bool? value) {
                  BlocProvider.of<CheckboxListCubit>(context)
                      .toggleCheckbox(word.id!);
                },
                value: (state as CheckboxListEnabled).values.contains(word.id!),
              ));
}
