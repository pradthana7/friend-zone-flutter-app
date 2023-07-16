import 'package:dating_app/blocs/blocs.dart';
import 'package:dating_app/cubits/signup/signup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/user_model.dart';

class CustomButtom extends StatelessWidget {
  final TabController tabController;
  final String text;

  const CustomButtom({
    Key? key,
    required this.tabController,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: LinearGradient(colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColorDark,
          ])),
      child: ElevatedButton(
        onPressed: () async {
          if (tabController.index == 6) {
            Navigator.pushNamed(context, '/');
          } else {
            tabController.animateTo(tabController.index + 1);
          }

          if (tabController.index == 2) {
            await context.read<SignupCubit>().signUpWithCredentials();

            User user = User(
              id: context.read<SignupCubit>().state.user?.uid,
              name: '',
              age: 0,
              gender: '',
              imageUrls: [],
              jobTitle: '',
              interests: [],
              bio: '',
              location: '',
              swipeLeft: [],
              swipeRight: [],
              matches: [],
              ageRangePreference: [18, 50],
              genderPreference: ['Female'],
            );

            context.read<OnboardingBloc>().add(
                  StartOnboarding(user: user),
                );
          }
        },
        child: Container(
          width: double.infinity,
          child: Center(
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
