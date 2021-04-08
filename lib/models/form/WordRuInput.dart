import 'package:formz/formz.dart';

enum UsernameValidationError { empty, alreadyExist }

Map<UsernameValidationError, String> humanizedErrors = {
  UsernameValidationError.empty: 'Required field',
};

class WordRuInput extends FormzInput<String, UsernameValidationError> {
  WordRuInput.pure({this.isLoaded = true}) : super.pure('');

  WordRuInput.dirty({String value = '', this.isLoaded = true}) : super.dirty(value);

  bool isLoaded = true;

  @override
  UsernameValidationError? validator(String? value) =>
      value?.isEmpty == true ? UsernameValidationError.empty : null;

  String? get humanizedError => humanizedErrors[this.error];
}
