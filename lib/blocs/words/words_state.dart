import 'package:equatable/equatable.dart';
import 'package:word_translation_picture/models/Word.dart';

abstract class WordsState extends Equatable {
  const WordsState();

  @override
  List<Object> get props => [];
}

class WordsLoadInProgress extends WordsState {}

class WordsLoadSuccess extends WordsState {
  final List<Word> words;

  const WordsLoadSuccess([this.words = const []]);

  @override
  List<Object> get props => [words];

  @override
  String toString() => 'WordsLoadSuccess { words: $words }';
}

class WordsLoadFailure extends WordsState {}
