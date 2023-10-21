import 'package:dating_app/blocs/onboarding/onboarding_bloc.dart';
import 'package:dating_app/screen/onboarding/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Start extends StatelessWidget {
  const Start({
    Key? key,
    required this.state,
  }) : super(key: key);

  final OnboardingLoaded state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.topCenter,
          height: 300,
          width: 500,
          child: Image.asset('assets/images/4friends.png'),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 0, right: 20, left: 20, bottom: 20),
          child: Expanded(
            child: Text(
              'Making friends at university can be tough, especially for freshmen. FZ is the new app that connects SUT students for easy friend-making. Simply create a profile, swipe right on potential friends, and chat when you match. With filtering by age, and gender, FZ introduces you to like-minded people. Whether you\'re looking to expand your circle or make meaningful connections, FZ helps break the ice so you can swipe, match and message your way to new friendships!',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
            ),
          ),
        ),
        const SizedBox(height: 14),
        CustomButton(
          text: 'Get Started',
          onPressed: () {
            context
                .read<OnboardingBloc>()
                .add(ContinueOnboarding(user: state.user));
          },
        ),
      ],
    );
  }
}
