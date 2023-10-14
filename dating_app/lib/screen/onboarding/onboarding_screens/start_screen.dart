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
              const EdgeInsets.only(top: 0, right: 20, left: 20, bottom: 30),
          child: Expanded(
            child: Text(
              'Hey there, welcome to FZ App! It\'s the perfect platform for students and young professionals like yourself to meet new people. You can easily show your interest by swiping left or right, and once you match with someone, go ahead and start a friendly chat. Feel free to personalize your profile and set your preferences for gender and age to meet like-minded individuals. So, why wait? Join us today!',
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
