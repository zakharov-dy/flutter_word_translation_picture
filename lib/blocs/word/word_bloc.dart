import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';
import 'package:word_translation_picture/blocs/words/words_bloc.dart';
import 'package:word_translation_picture/blocs/words/words_state.dart';
import 'package:word_translation_picture/dataProvider/Repository.dart';
import 'package:word_translation_picture/models/form/WordEnInput.dart';
import 'package:collection/collection.dart';
import 'package:word_translation_picture/models/form/WordRuInput.dart';

part 'word_event.dart';

part 'word_state.dart';

bool Function() isAlwaysFalse = () => false;

class WordBloc extends Bloc<WordEvent, WordState> {
  final Repository wordsRepository;
  final WordsBloc wordsBloc;

  WordBloc({required this.wordsRepository, required this.wordsBloc})
      : super(WordState(
            engInput: WordEnInput.pure(isAlreadyExist: isAlwaysFalse),
            ruInput: WordRuInput.pure()));

  @override
  Stream<WordState> mapEventToState(
    WordEvent event,
  ) async* {
    if (event is EngInputChangedEvent) {
      yield _mapEngInputChangedToState(event, state);
    } else if (event is TranslateEvent) {
      yield* _mapTranslateToState(state);
    } else if (event is RuInputChangedEvent) {
      yield _mapRuInputChangedToState(event, state);
    } else if (event is WordSubmittedEvent) {
      yield* _mapWordSubmittedToState(event, state);
    }
  }

  WordState _mapEngInputChangedToState(
    EngInputChangedEvent event,
    WordState state,
  ) {
    final engInput = WordEnInput.dirty(value: event.engInput, isAlreadyExist: _isAlreadyExist);
    return state.copyWith(
      engInput: engInput,
      status: Formz.validate([engInput]),
    );
  }

  WordState _mapRuInputChangedToState(
    RuInputChangedEvent event,
    WordState state,
  ) {
    final ruInput = WordRuInput.dirty(value: event.ruInput);
    return state.copyWith(
      ruInput: ruInput,
      status: Formz.validate([ruInput]),
    );
  }

  Stream<WordState> _mapTranslateToState(
    WordState state,
  ) async* {
    var engInput = state.engInput;
    if (engInput.valid && engInput.value != '') {
      var oldValue = state.ruInput;
      try {
        final ruInput = WordRuInput.pure(isLoaded: false);
        yield state.copyWith(
          ruInput: ruInput,
        );

        final translation = await wordsRepository.getTranslations(
          text: engInput.value,
        );

        if (translation?.first != null && translation?.first.text != null) {
          print(translation!.first.text!);
          final ruInput = WordRuInput.dirty(value: translation.first.text!);
          yield state.copyWith(
            ruInput: ruInput,
            status: Formz.validate([ruInput]),
          );
        } else {
          yield state.copyWith(ruInput: oldValue);
        }
      } on Exception catch (_) {
        yield state.copyWith(ruInput: oldValue);
      }
    }
  }

  Stream<WordState> _mapWordSubmittedToState(
    WordSubmittedEvent event,
    WordState state,
  ) async* {
    if (state.status.isValidated) {
      yield state.copyWith(status: FormzStatus.submissionSuccess, translation: state.ruInput.value);
    }
  }

  bool _isAlreadyExist(String value) {
    if (wordsBloc.state is WordsLoadSuccess) {
      return ((wordsBloc.state as WordsLoadSuccess).words.firstWhereOrNull((e) => e.en == value) !=
          null);
    }

    return false;
  }
}
