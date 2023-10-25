import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/blocs/blocs.dart';

import '/screen/screens.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = '/splash';

  const SplashScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const SplashScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) {
          return previous.authUser != current.authUser ||
              current.authUser == null;
        },
        listener: (context, state) {
          // print("Splash Screen Listener");
          if (state.status == AuthStatus.unauthenticated) {
            Timer(
              const Duration(seconds: 1),
              () => Navigator.of(context).pushNamed(
                LoginScreen.routeName,
              ),
            );
          } else if (state.status == AuthStatus.authenticated) {
            Timer(
              const Duration(seconds: 1),
              () => Navigator.of(context).pushNamed(HomeScreen.routeName),
            );
          }
        },
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/newlogo.png',
                  height: 100,
                ),
                const SizedBox(height: 20),
                Text(
                  'Friend Zone',
                  style: Theme.of(context).textTheme.headlineLarge,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
