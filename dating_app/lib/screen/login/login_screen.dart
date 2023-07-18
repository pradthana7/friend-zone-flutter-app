import 'package:dating_app/blocs/auth/auth_bloc.dart';
import 'package:dating_app/cubits/login/login_cubit.dart';
import 'package:dating_app/screen/home/home_screen.dart';
import 'package:dating_app/screen/onboarding/onboarding_screen.dart';
import 'package:formz/formz.dart';

import 'package:dating_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) {
        return BlocProvider.of<AuthBloc>(context).state.status ==
                AuthStatus.authenticated
            ? HomeScreen()
            : LoginScreen();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'F-R-I-E-N-D-S',
        hasActions: false,
      ),
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status.isSubmissionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Auth failure'),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _EmailInput(),
              const SizedBox(height: 10),
              _PasswordInput(),
              const SizedBox(height: 10),
              _LoginButton(),
              const SizedBox(height: 10),
              CustomElevatedButton(
                text: 'Sign up',
                beginColor: Theme.of(context).primaryColor,
                endColor: Color.fromARGB(255, 115, 211, 144),
                textColor: Colors.white,
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  OnboardingScreen.routeName,
                  ModalRoute.withName('/onboarding'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(buildWhen: ((previous, current) {
      return previous.status != current.status;
    }), builder: (context, state) {
      return state.status == FormzStatus.submissionInProgress
          ? CircularProgressIndicator()
          : CustomElevatedButton(
              text: 'Sign in',
              beginColor: const Color.fromARGB(255, 225, 116, 152),
              endColor: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () {
                state.status == FormzStatus.valid
                    ? context.read<LoginCubit>().logInWithCredentials()
                    : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Check your emai and password: ${state.status}')));
              });
    });
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
        buildWhen: ((previous, current) => previous.email != current.email),
        builder: (context, state) {
          return TextField(
            onChanged: (email) {
              context.read<LoginCubit>().emailChanged(email);
            },
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                labelText: 'Email',
                errorText: state.email.invalid ? 'The email is invalid' : null),
          );
        });
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
        buildWhen: ((previous, current) =>
            previous.password != current.password),
        builder: (context, state) {
          return TextField(
            onChanged: (password) {
              context.read<LoginCubit>().passwordChanged(password);
            },
            decoration: InputDecoration(
                labelText: 'Password',
                errorText: state.password.invalid
                    ? 'The password must contain at least 8 characters'
                    : null),
            obscureText: true,
          );
        });
  }
}
