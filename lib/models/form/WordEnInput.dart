import 'package:formz/formz.dart';

enum UsernameValidationError { empty, alreadyExist }

Map<UsernameValidationError, String> humanizedErrors = {
  UsernameValidationError.empty: 'Required field',
  UsernameValidationError.alreadyExist: 'Already added to dictionary'
};

class WordEnInput extends FormzInput<String, UsernameValidationError> {
  Function isAlreadyExist;

  WordEnInput.pure({required this.isAlreadyExist}) : super.pure('');
  WordEnInput.dirty({String value = '', required this.isAlreadyExist}) : super.dirty(value);


  @override
  UsernameValidationError? validator(String? value) {
    if(value?.isEmpty == true){
      return UsernameValidationError.empty;
    }

    if(this.isAlreadyExist(value) == true){
      return UsernameValidationError.alreadyExist;
    }

    return null;
  }

  String? get humanizedError => humanizedErrors[this.error];
}
