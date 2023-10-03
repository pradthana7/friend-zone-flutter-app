import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/widgets.dart';
import '../../screens.dart';
import '/blocs/blocs.dart';
import '/screen/onboarding/widgets/widgets.dart';

class Bio extends StatefulWidget {
  Bio({
    Key? key,
    required this.state,
  }) : super(key: key);

  final OnboardingLoaded state;

  @override
  _BioState createState() => _BioState();
}

class _BioState extends State<Bio> {
  List<String> selectedInterests = []; // Store selected interests here

  final List<String> interests = [
    'Music',
    'Sports',
    'Travel',
    'Food',
    'Photography',
    'Art',
    'Movies',
    'Reading',
    'Gaming',
    'Fashion',
    'Fitness',
    'Cooking',
    'Technology',
    'Dancing',
    'Nature',
    'Writing',
    'Yoga',
    'History',
    'Cars',
    'Pets',
    'Computer Engineering'
  ];

  @override
  Widget build(BuildContext context) {
    return OnboardingScreenLayout(
      currentStep: 5,
      onPressed: () {
        Navigator.pushNamed(context, HomeScreen.routeName);
      },
      children: [
        const CustomTextHeader(text: 'About Me'),
        const SizedBox(height: 20.0),
        CustomTextField(
          hintText: 'I am beatiful...',
          onChanged: (value) {
            context.read<OnboardingBloc>().add(
                  UpdateUser(
                    user: widget.state.user.copyWith(bio: value),
                  ),
                );
          },
        ),
        SizedBox(height: 50),
        CustomTextHeader(text: 'What do you do?'),
        const SizedBox(height: 20.0),
        CustomTextField(
          hintText: 'Software Engineer',
          onChanged: (value) {
            context.read<OnboardingBloc>().add(
                  UpdateUser(
                    user: widget.state.user.copyWith(jobTitle: value),
                  ),
                );
          },
        ),
        const SizedBox(height: 50),
        const CustomTextHeader(text: 'Interests'),
        Wrap(
          spacing: 2.0,
          runSpacing: 2.0,
          children: [
            ChipsChoice<String>.multiple(
              wrapped: true,
              value: selectedInterests,
              onChanged: (val) {
                setState(() {
                  selectedInterests = val;
                });
                context.read<OnboardingBloc>().add(
                      UpdateUser(
                        user: widget.state.user.copyWith(interests: val),
                      ),
                    );
              },
              choiceItems: C2Choice.listFrom<String, String>(
                source: interests,
                value: (i, v) => v,
                label: (i, v) => v,
                tooltip: (i, v) => v,
              ),
              choiceCheckmark: true,
              choiceStyle: C2ChipStyle(
                checkmarkColor: Colors.red.shade400,
                backgroundColor: Colors.red,
                checkmarkWeight: 1.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
