import 'package:equatable/equatable.dart';
import 'package:word_translation_picture/models/Word.dart';

abstract class WordsEvents extends Equatable {
  const WordsEvents();

  @override
  List<Object> get props => [];
}

class WordsLoaded extends WordsEvents {}

class WordAddedEvent extends WordsEvents {
  final Word word;

  const WordAddedEvent(this.word);

  @override
  List<Object> get props => [word];

  @override
  String toString() => 'WordAddedEvent { word: $word }';
}

class WordUpdatedEvent extends WordsEvents {
  final Word word;

  const WordUpdatedEvent(this.word);

  @override
  List<Object> get props => [word];

  @override
  String toString() => 'WordUpdatedEvent { word: $word }';
}

class WordDeletedEvent extends WordsEvents {
  final Word word;

  const WordDeletedEvent(this.word);

  @override
  List<Object> get props => [word];

  @override
  String toString() => 'WordDeletedEvent { word: $word }';
}
