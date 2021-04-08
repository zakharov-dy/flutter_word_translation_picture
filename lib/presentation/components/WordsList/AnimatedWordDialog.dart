import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:word_translation_picture/presentation/components/WordDialog.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_translation_picture/models/Word.dart';

class WordDialogCubitState extends Equatable {
  WordDialogCubitState({this.word, required this.isShown});

  Word? word;
  bool isShown;

  WordDialogCubitState copyWith({Word? word, bool? soonBeingClose}) =>
      WordDialogCubitState(word: word ?? this.word, isShown: soonBeingClose ?? this.isShown);

  @override
  List<Object?> get props => [word, isShown];
}

class WordDialogCubit extends Cubit<WordDialogCubitState> {
  WordDialogCubit() : super(WordDialogCubitState(word: null, isShown: false));

  void openDialog(Word word) async {
    emit(WordDialogCubitState(word: word, isShown: true));
  }

  void closeDialog() async {
    emit(WordDialogCubitState(word: state.word, isShown: false));
    await Future.delayed(Duration(milliseconds: 600));
    emit(WordDialogCubitState(word: null, isShown: false));
  }
}

class AnimatedWordDialog extends StatefulWidget {
  final Word word;
  final bool isShown;

  const AnimatedWordDialog({Key? key, required this.word, required this.isShown}) : super(key: key);

  @override
  State<AnimatedWordDialog> createState() => _AnimatedWordDialog(word: word, isShown: isShown);
}

class _AnimatedWordDialog extends State<AnimatedWordDialog>
    with TickerProviderStateMixin {
  _AnimatedWordDialog({required this.word, required this.isShown}) : super();

  final Word word;
  final bool isShown;
  late final AnimationController _controller;
  late final Animation<double> _animation;

  initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.ease,
    );

    if (isShown) {
      _controller.forward();
    } else {
      _controller.reverse(from: 1.0);
    }
  }


  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
      child: ScaleTransition(
          scale: _animation,
          child: WordDialog(word: word)
      ),
    );
  }
}
