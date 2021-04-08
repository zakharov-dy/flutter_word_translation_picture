part of 'word_bloc.dart';

class WordState extends Equatable {
  WordState({this.status = FormzStatus.pure, required this.engInput, required this.ruInput});

  final FormzStatus status;
  final WordEnInput engInput;
  final WordRuInput ruInput;

  WordState copyWith(
          {FormzStatus? status,
          WordEnInput? engInput,
          WordRuInput? ruInput,
          String? translation}) =>
      WordState(
        status: status ?? this.status,
        engInput: engInput ?? this.engInput,
        ruInput: ruInput ?? this.ruInput,
      );

  @override
  List<Object?> get props => [status, engInput, ruInput];
}
