import 'package:dating_app/blocs/blocs.dart';
import 'package:dating_app/config/theme.dart';
import 'package:dating_app/cubits/signup/signup_cubit.dart';
import 'package:dating_app/repositories/auth/auth_repository.dart';
import 'package:dating_app/repositories/database/database_repository.dart';
import 'package:dating_app/repositories/storage/storage_repository.dart';
import 'package:flutter/material.dart';
import 'package:dating_app/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'onboarding_screens/screens.dart';
import 'widgets/dot_step_indicator.dart';

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
    Tab(text: 'Demographics'),
    Tab(text: 'Pictures'),
    Tab(text: 'Biography'),
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
            title: '',
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
                    Demo(state: state),
                    Pictures(state: state),
                    Bio(state: state),
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

// class OnboardingScreenLayout extends StatelessWidget {
//   const OnboardingScreenLayout({
//     Key? key,
//     required this.currentStep,
//     required this.onPressed,
//     required this.children,
//   }) : super(key: key);

//   final int currentStep;
//   final Function()? onPressed;
//   final List<Widget> children;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: children,
//             ),
//           ),
//         ),
//         StepProgressIndicator(
//           roundedEdges: Radius.circular(20),
//           totalSteps: 5,
//           currentStep: currentStep,
//           selectedColor: Theme.of(context).primaryColorDark,
//           unselectedColor: Theme.of(context).primaryColorLight,
//         ),
//         SizedBox(height: 10),
//         CustomButton(
//           text: 'next',
//           onPressed: onPressed, alignment: Alignment.bottomCenter,
//         ),
//       ],
//     );
//   }
// }

class OnboardingScreenLayout extends StatelessWidget {
  const OnboardingScreenLayout({
    Key? key,
    required this.currentStep,
    required this.onPressed,
    required this.children,
  }) : super(key: key);

  final int currentStep;
  final Function()? onPressed;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            DotStepIndicator(
              totalSteps: 5,
              currentStep: currentStep,
            ),
            if (currentStep > 1)
              // IconButton(
              //   onPressed: onPressed,
              //   icon: Icon(Icons.arrow_right_alt_rounded),
              //   color: Color.fromARGB(255, 155, 113, 54),
              //   iconSize: 40,
              // )
              TextButton(
                onPressed: onPressed,
                child: Text(
                  'Next',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 25),
                ),
              )
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
