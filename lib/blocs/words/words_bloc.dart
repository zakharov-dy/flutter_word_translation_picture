import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:word_translation_picture/blocs/words/words_events.dart';
import 'package:word_translation_picture/blocs/words/words_state.dart';
import 'package:word_translation_picture/dataProvider/Repository.dart';
import 'package:word_translation_picture/models/DB/DBWord.dart';
import 'package:word_translation_picture/models/Word.dart';

import '../../objectbox.g.dart';

class WordsBloc extends Bloc<WordsEvents, WordsState> {
  final Repository wordsRepository;
  final Box<DBWord> box;

  WordsBloc({required this.wordsRepository, required this.box}) : super(WordsLoadInProgress());

  @override
  Stream<WordsState> mapEventToState(WordsEvents event) async* {
    if (event is WordsLoaded) {
      yield* _mapWordsLoadedToState();
    } else if (event is WordAddedEvent) {
      yield* _mapWordAddedToState(event);
    } else if (event is WordUpdatedEvent) {
      yield* _mapWordUpdatedToState(event);
    } else if (event is WordDeletedEvent) {
      yield* _mapWordDeletedToState(event);
    }
  }

  Stream<WordsState> _mapWordsLoadedToState() async* {
    try {
      if (box.count() == 0) {
        final words = await wordsRepository.getInitialPreparedWords();
        final dbWords = words!.map((e) => updateDBWord(e,  DBWord())).toList();
        box.putMany(dbWords);
      }
      final words = box.getAll().map((e) {
        final word = Word(en: e.en!, ru: e.ru!, image: e.image);
        word.id = e.id;
        return word;
      }).toList();
      yield WordsLoadSuccess(words);
    } catch (_) {
      yield WordsLoadFailure();
    }
  }

  Stream<WordsState> _mapWordAddedToState(WordAddedEvent event) async* {
    if (state is WordsLoadSuccess) {
      final wordDB = DBWord();
      updateDBWordAndSave(event.word, wordDB);
      final List<Word> updatedWords = List.from((state as WordsLoadSuccess).words)..add(event.word);
      yield WordsLoadSuccess(updatedWords);
      event.word.id = wordDB.id;
    }
  }

  Stream<WordsState> _mapWordUpdatedToState(WordUpdatedEvent event) async* {
    if (state is WordsLoadSuccess) {
      if (event.word.id != null) {
        final wordDB = box.get(event.word.id!);
        updateDBWordAndSave(event.word, wordDB!);
      }

      final List<Word> updatedWords = (state as WordsLoadSuccess).words.map((word) {
        return word.en == event.word.en ? event.word : word;
      }).toList();
      yield WordsLoadSuccess(updatedWords);
    }
  }

  Stream<WordsState> _mapWordDeletedToState(WordDeletedEvent event) async* {
    if (state is WordsLoadSuccess) {
      final updatedWords =
          (state as WordsLoadSuccess).words.where((word) => word != event.word).toList();
      if(event.word.id != null){
        box.remove(event.word.id!);
      }
      yield WordsLoadSuccess(updatedWords);
    }
  }

  DBWord updateDBWord(Word word, DBWord wordDB) {
    wordDB.image = word.image;
    wordDB.ru = word.ru;
    wordDB.en = word.en;

    return wordDB;
  }

  DBWord updateDBWordAndSave(Word word, DBWord wordDB) {
    updateDBWord(word, wordDB);
    box.put(wordDB);

    return wordDB;
  }
}
