import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_translation_picture/blocs/words/words_bloc.dart';
import 'package:word_translation_picture/blocs/words/words_state.dart';
import 'package:word_translation_picture/presentation/HomePage/words_view_type_cubit.dart';
import 'package:word_translation_picture/presentation/components/WordsList/WordsList.dart';
import 'package:word_translation_picture/presentation/components/share/nothing.dart';

class Search extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Search...';

  @override
  TextStyle get searchFieldStyle => TextStyle(
        color: Colors.white,
        fontSize: 18.0,
      );

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context).copyWith(
      textTheme: Theme.of(context).textTheme.merge(TextTheme(
              headline6: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ))),
      inputDecorationTheme: InputDecorationTheme(
        // ¯\_(ツ)_/¯
        hintStyle: searchFieldStyle,
        border: InputBorder.none,
      ),
    );

    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.search_off),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  String selectedResult = '';

  @override
  Widget buildResults(BuildContext context) => nothing;

  @override
  Widget buildSuggestions(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        // GestureDetector not working
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.focusedChild!.unfocus();
        }
      },
      child: BlocBuilder<WordsBloc, WordsState>(builder: (context, state) {
        return WordsList(
            words: (state as WordsLoadSuccess)
                .words
                .where(
                  (element) => element.en.contains(query),
                )
                .toList(),
            type: WordsViewType.list);
      }),
    );
  }
}
