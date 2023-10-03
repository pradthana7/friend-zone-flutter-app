import 'dart:async';

import 'package:dating_app/screen/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/blocs/blocs.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/screen/screens.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = '/splash';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => SplashScreen(),
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
          print("Splash Screen Listener");
          if (state.status == AuthStatus.unauthenticated) {
            Timer(
              Duration(seconds: 1),
              () => Navigator.of(context).pushNamed(
                LoginScreen.routeName,
              ),
            );
          } else if (state.status == AuthStatus.authenticated) {
            Timer(
              Duration(seconds: 1),
              () => Navigator.of(context).pushNamed(HomeScreen.routeName),
            );
          }
        },
        child: Scaffold(
          body: Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 100,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Friend Zone',
                    style: Theme.of(context).textTheme.headlineLarge,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
