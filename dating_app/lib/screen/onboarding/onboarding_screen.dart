// import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/blocs/blocs.dart';
import 'package:dating_app/cubits/signup/signup_cubit.dart';
import 'package:dating_app/repositories/auth/auth_repository.dart';
import 'package:dating_app/repositories/database/database_repository.dart';
import 'package:dating_app/repositories/storage/storage_repository.dart';
import 'package:flutter/material.dart';
import 'package:dating_app/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'onboarding_screens/screens.dart';
import 'widgets/widgets.dart';

class OnboardingScreen extends StatelessWidget {
  static const String routeName = '/onboarding';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider<OnboardingBloc>(
            create: (context) => OnboardingBloc(
              databaseRepository: context.read<DatabaseRepository>(),
              storageRepository: context.read<StorageRepository>(),
            ),
          ),
          BlocProvider<SignupCubit>(
            create: (context) => SignupCubit(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
        ],
        child: OnboardingScreen(),
      ),
    );
  }

  static const List<Tab> tabs = <Tab>[
    Tab(text: 'Start'),
    Tab(text: 'Email'),
    // Tab(text: 'Email Verification'),
    Tab(text: 'Demographics'),
    Tab(text: 'Pictures'),
    Tab(text: 'Biography'),
    Tab(text: 'Location'),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context)!;

        context
            .read<OnboardingBloc>()
            .add(StartOnboarding(tabController: tabController));
        return Scaffold(
          appBar: CustomAppBar(
            title: 'F-R-I-E-N-D-S',
            hasActions: false,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 50,
            ),
            child: BlocBuilder<OnboardingBloc, OnboardingState>(
                builder: (context, state) {
              if (state is OnboardingLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is OnboardingLoaded) {
                return TabBarView(
                  children: [
                    Start(state: state),
                    Email(state: state),
                    // EmailVerification(),
                    Demo(state: state),
                    Pictures(state: state),
                    Bio(state: state),
                    Location(state: state),
                  ],
                );
              } else {
                return Text('Something went wrong');
              }
            }),
          ),
        );
      }),
    );
  }
}

class OnboardingScreenLayout extends StatelessWidget {
  const OnboardingScreenLayout(
      {Key? key,
      required this.currentStep,
      required this.onPressed,
      required this.children})
      : super(key: key);

  final int currentStep;
  final Function()? onPressed;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              minWidth: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...children,
                  Spacer(),
                  SizedBox(
                    height: 75,
                    child: Column(
                      children: [
                        StepProgressIndicator(
                          totalSteps: 6,
                          currentStep: currentStep,
                          selectedColor: Theme.of(context).primaryColor,
                          unselectedColor: Theme.of(context).disabledColor,
                        ),
                        SizedBox(height: 10),
                        CustomButton(
                          text: 'NEXT',
                          onPressed: onPressed,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

