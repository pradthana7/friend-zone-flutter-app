import 'package:dating_app/blocs/auth/auth_bloc.dart';
import 'package:dating_app/cubits/login/login_cubit.dart';
import 'package:dating_app/screen/home/home_screen.dart';
import 'package:dating_app/screen/onboarding/onboarding_screen.dart';
import 'package:dating_app/widgets/loading_indicator.dart';
import 'package:formz/formz.dart';

import 'package:dating_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        return BlocProvider.of<AuthBloc>(context).state.status ==
                AuthStatus.authenticated
            ? const HomeScreen()
            : LoginScreen();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/newlogo.png',
                scale: 2,
                alignment: Alignment.center,
              ),
              const SizedBox(height: 50),
              _EmailInput(),
              const SizedBox(height: 30),
              _PasswordInput(),
              const SizedBox(height: 30),
              const _LoginButton(),
              const SizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a member? ',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 18),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamedAndRemoveUntil(
                      OnboardingScreen.routeName,
                      ModalRoute.withName('/onboarding'),
                    ),
                    child: const Text(
                      'Register',
                      style:
                          TextStyle(color: Color(0xfffa9200), fontSize: 18),
                    ),
                  ),
                ],
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
          ? LoadingIndicator()
          : CustomElevatedButton(
              text: 'Sign in',
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () {
                state.status == FormzStatus.valid
                    ? context.read<LoginCubit>().logInWithCredentials()
                    : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Check your emai and password: ${state.status}')));
              }, fontSize: 18,);
    });
  }
}





class _EmailInput extends StatefulWidget {
  @override
  __EmailInputState createState() => __EmailInputState();
}

class __EmailInputState extends State<_EmailInput> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          controller: _emailController,
          onChanged: (email) {
            context.read<LoginCubit>().emailChanged(email);
          },
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.email),
            suffixIcon: _emailController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _emailController.clear();
                      });
                    },
                    icon: const Icon(Icons.close_rounded),
                  )
                : null, // Show null when no input to hide the icon
            labelText: 'E-MAIL',
            errorText: state.email.invalid ? 'The email is invalid' : null,
          ),
        );
      },
    );
  }
}



class _PasswordInput extends StatefulWidget {
  @override
  __PasswordInputState createState() => __PasswordInputState();
}

class __PasswordInputState extends State<_PasswordInput> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          controller: _passwordController,
          onChanged: (password) {
            context.read<LoginCubit>().passwordChanged(password);
          },
          decoration: InputDecoration(
            iconColor: Theme.of(context).primaryColor,
            prefixIcon: const Icon(Icons.key),
            labelText: 'PASSWORD',
            errorText: state.password.invalid
                ? 'The password must contain at least 8 characters'
                : null,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          obscureText: !_isPasswordVisible,
        );
      },
    );
  }
}
