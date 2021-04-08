part of 'word_bloc.dart';

@immutable
abstract class WordEvent extends Equatable {
  const WordEvent();

  @override
  List<Object> get props => [];
}

class EngInputChangedEvent extends WordEvent {
  const EngInputChangedEvent(this.engInput);

  final String engInput;

  @override
  List<Object> get props => [engInput];
}

class RuInputChangedEvent extends WordEvent {
  const RuInputChangedEvent(this.ruInput);

  final String ruInput;

  @override
  List<Object> get props => [ruInput];
}

class TranslateEvent extends WordEvent {
}

class WordSubmittedEvent extends WordEvent {
  const WordSubmittedEvent();
}
