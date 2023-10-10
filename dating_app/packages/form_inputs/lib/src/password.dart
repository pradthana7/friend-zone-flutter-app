import 'package:formz/formz.dart';

enum PasswordValidationError { invalid }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');

  const Password.dirty([String value = '']) : super.dirty(value);

  static final RegExp _passwordRegExp = RegExp(
    r'^(?=[^a-z]*[a-z])(?=[^A-Z]*[A-Z])(?=\D*\d)(?=[^!#%]*[!#%])[A-Za-z0-9!#%]{8,32}$',
  );

  @override
  PasswordValidationError? validator(String value) {
    return _passwordRegExp.hasMatch(value ?? '')
        ? null
        : PasswordValidationError.invalid;
  }
}

// Must include at least 1 lower-case letter.
// Must include at least 1 upper-case letter.
// Must include at least 1 number.
// Must include at least 1 special character (only the following special characters are allowed: !#%).
// Must NOT include any other characters then A-Za-z0-9!#% 
// Must be from 8 to 32 characters long.
