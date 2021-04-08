import 'package:word_translation_picture/models/Word.dart';

wordToImageTag(Word word) => 'word-image-tag-${word.id.toString()}';
wordToRuTag(Word word) => 'word-ru-tag-${word.id.toString()}';
wordToEngTag(Word word) => 'word-eng-tag-${word.id.toString()}';
