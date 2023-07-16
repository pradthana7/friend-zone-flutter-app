import 'package:dating_app/blocs/auth/auth_bloc.dart';
import 'package:dating_app/cubits/login/login_cubit.dart';
import 'package:dating_app/screen/home/home_screen.dart';
import 'package:dating_app/screen/onboarding/onboarding_screen.dart';
import 'package:dating_app/widgets/custom_appbar.dart';
import 'package:dating_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) {
        return BlocProvider.of<AuthBloc>(context).state.status ==
                AuthStatus.authenticated
            ?  HomeScreen()
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmailInput(),
            const SizedBox(height: 10),
            PasswordInput(),
            const SizedBox(height: 10),
            CustomElevatedButton(
                text: 'Sign in',
                beginColor: const Color.fromARGB(255, 225, 116, 152),
                endColor: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed: () {
                  context.read<LoginCubit>().logInWithCredentials();
                }),
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
    );
  }
}

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
        buildWhen: ((previous, current) => previous.email != current.email),
        builder: (context, State) {
          return TextField(
            onChanged: (email) {
              context.read<LoginCubit>().emailChanged(email);
            },
            decoration: const InputDecoration(labelText: 'Email'),
          );
        });
  }
}

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
        buildWhen: ((previous, current) =>
            previous.password != current.password),
        builder: (context, State) {
          return TextField(
            onChanged: (password) {
              context.read<LoginCubit>().passwordChanged(password);
            },
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          );
        });
  }
}
