import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_translation_picture/blocs/words/words_bloc.dart';
import 'package:word_translation_picture/blocs/words/words_events.dart';
import 'package:word_translation_picture/blocs/words/words_state.dart';
import 'package:word_translation_picture/models/Word.dart';
import 'package:word_translation_picture/presentation/CardsPage.dart';
import 'package:word_translation_picture/presentation/HomePage/Search.dart';
import 'package:word_translation_picture/blocs/checkbox_list/checkbox_list_cubit.dart';
import 'package:word_translation_picture/presentation/HomePage/words_view_type_cubit.dart';
import 'package:word_translation_picture/presentation/NewWordPage.dart';
import 'package:word_translation_picture/presentation/components/WordsList/WordsList.dart';
import 'package:word_translation_picture/presentation/components/share/centerCircularProgressIndicator.dart';
import 'package:word_translation_picture/presentation/components/share/nothing.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/';

  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  final viewTypeCubit = WordsViewTypeCubit();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          _CheckboxIconButton(),
          _ViewTypeIconButton(
            cubit: viewTypeCubit,
          ),
          _SearchIconButton()
        ],
      ),
      body: BlocBuilder<WordsBloc, WordsState>(
        builder: (context, state) {
          if (state is WordsLoadInProgress) {
            return centerCircularProgressIndicator;
          } else if (state is WordsLoadSuccess) {
            final words = state.words;
            return BlocBuilder<WordsViewTypeCubit, WordsViewType?>(
                bloc: viewTypeCubit,
                builder: (context, state) => state != null
                    ? WordsList(words: words, type: state)
                    : centerCircularProgressIndicator);
          } else {
            return nothing;
          }
        },
      ),
      floatingActionButton: _FloatingActionButton(),
    );
  }
}

class _ViewTypeIconButton extends StatelessWidget {
  _ViewTypeIconButton({required this.cubit}) : super();

  final WordsViewTypeCubit cubit;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<WordsViewTypeCubit, WordsViewType?>(
        bloc: cubit,
        builder: (context, state) => IconButton(
            onPressed: cubit.change,
            icon: cubit.state == WordsViewType.list
                ? const Icon(Icons.view_headline_sharp)
                : const Icon(Icons.view_module_rounded)),
      );
}

class _SearchIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocBuilder<WordsBloc, WordsState>(
      builder: (context, state) => state is WordsLoadSuccess
          ? IconButton(
              onPressed: () {
                BlocProvider.of<CheckboxListCubit>(context).disable();
                showSearch(context: context, delegate: Search());
              },
              icon: const Icon(Icons.search),
            )
          : nothing);
}

class _CheckboxIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<CheckboxListCubit, CheckboxListState?>(
        builder: (context, state) => IconButton(
            onPressed: BlocProvider.of<CheckboxListCubit>(context).toggleState,
            icon: state is CheckboxListDisabled
                ? const Icon(Icons.indeterminate_check_box_outlined)
                : const Icon(Icons.check_box_outlined)),
      );
}

class _FloatingActionButton extends StatelessWidget {
  void _addNewWord(BuildContext context) async {
    final result =
        await Navigator.pushNamed(context, NewWordPage.routeName) as Word?;

    if (result != null) {
      BlocProvider.of<WordsBloc>(context).add(WordAddedEvent(result));
    }
  }

  void _learnWords(BuildContext context, Set<int> ids) async {
    BlocProvider.of<CheckboxListCubit>(context).disable();
    final state = BlocProvider.of<WordsBloc>(context).state;
    if (state is WordsLoadSuccess) {
      Navigator.pushNamed(context, CardsPage.routeName,
          arguments: state.words
              .where(
                (element) => ids.contains(element.id),
              )
              .toList());
    }
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<CheckboxListCubit, CheckboxListState?>(
          builder: (context, state) => state is CheckboxListDisabled
              ? FloatingActionButton(
                  onPressed: () => _addNewWord(context),
                  child: Icon(Icons.add),
                )
              : FloatingActionButton(
                  onPressed: (state as CheckboxListEnabled).isEmpty
                      ? null
                      : () => _learnWords(context, state.values),
                  child: Icon(Icons.map),
                  backgroundColor:
                      state.isEmpty ? Colors.grey : Colors.deepOrange,
                ));
}
