part of 'signup_cubit.dart';

enum SignupStatus { initial, submitting, success, error }

class SignupState extends Equatable {
  final Email email;
  final Password password;
  final FormzStatus status;
  final auth.User? user;

  const SignupState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzStatus.pure,
    this.user,
  });

  factory SignupState.initial() {
    return const SignupState(
      email:  Email.pure(),
      password:  Password.pure(),
      status: FormzStatus.pure,
      user: null,
    );
  }



  @override
  List<Object?> get props => [email, password, status, user];

  SignupState copyWith({
    Email? email,
    Password? password,
    FormzStatus? status,
    auth.User? user,
  }) {
    return SignupState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }
}
