import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:word_translation_picture/blocs/word/word_bloc.dart';
import 'package:word_translation_picture/models/Word.dart';
import 'package:word_translation_picture/presentation/components/PickPictureDialog.dart';
import 'package:word_translation_picture/presentation/components/share/centerCircularProgressIndicator.dart';

class NewWordPage extends StatelessWidget {
  static const routeName = '/add';

  NewWordPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: BlocListener<WordBloc, WordState>(
          listener: (context, state) async {
            if (state.status.isSubmissionSuccess) {
              final image = await Navigator.push(
                context,
                PageRouteBuilder(
                  barrierDismissible: true,
                  opaque: false,
                  pageBuilder: (_, anim1, anim2) => FadeTransition(
                    opacity: anim1,
                    child: PickPictureDialog(eng: state.engInput.value),
                  ),
                ),
              ) as String?;

              Navigator.pop(
                  context, Word(ru: state.ruInput.value, en: state.engInput.value, image: image));

              return;
            }
          },
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                  alignment: const Alignment(0, -1 / 3),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _EngInput(),
                      const Padding(padding: EdgeInsets.all(6)),
                      _RuInput(),
                      const Padding(padding: EdgeInsets.all(12)),
                      _WordButton(),
                    ],
                  )))),
    );
  }
}

class _EngInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WordBloc, WordState>(
      buildWhen: (previous, current) => previous.engInput != current.engInput,
      builder: (context, state) {
        return TextField(
          key: const Key('wordForm_engInput_textField'),
          onChanged: (eng) => context.read<WordBloc>().add(EngInputChangedEvent(eng)),
          decoration: InputDecoration(
            labelText: 'eng word',
            errorText: state.engInput.invalid ? state.engInput.humanizedError : null,
          ),
        );
      },
    );
  }
}

class _RuInput extends StatefulWidget {
  @override
  _RuInputState createState() => _RuInputState();
}

var iconIndicator = Container(
  child: centerCircularProgressIndicator,
  width: 10,
  height: 10,
);

class _RuInputState extends State<_RuInput> {
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WordBloc, WordState>(
      buildWhen: (previous, current) =>
          previous.ruInput != current.ruInput || previous.engInput != current.engInput,
      listener: (context, state) {
        myController.value = myController.value.copyWith(
          text: state.ruInput.value,
          selection: TextSelection.collapsed(offset: state.ruInput.value.length),
        );
      },
      builder: (context, state) {
        return TextField(
          controller: myController,
          key: const Key('wordForm_ruInput_textField'),
          onChanged: (ru) => context.read<WordBloc>().add(RuInputChangedEvent(ru)),
          decoration: InputDecoration(
            suffixIcon: state.ruInput.isLoaded
                ? IconButton(
                    icon: Icon(Icons.translate_rounded),
                    onPressed: state.engInput.value != ''
                        ? () => context.read<WordBloc>().add(TranslateEvent())
                        : null,
                  )
                : iconIndicator,
            labelText: 'run word',
            errorText: state.ruInput.invalid ? state.ruInput.humanizedError : null,
          ),
        );
      },
    );
  }
}

class _WordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocBuilder<WordBloc, WordState>(
      buildWhen: (previous, current) =>
          previous.status != current.status || previous.ruInput != current.ruInput,
      builder: (context, state) =>
          state.status.isSubmissionFailure || state.status.isSubmissionInProgress
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  key: const Key('wordForm_save_raisedButton'),
                  child: const Text('Save'),
                  onPressed: state.status.isValid && state.ruInput.isLoaded
                      ? () => context.read<WordBloc>().add(const WordSubmittedEvent())
                      : null,
                ));
}
