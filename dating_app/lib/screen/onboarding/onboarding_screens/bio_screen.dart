
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    double screenWidth = MediaQuery.of(context).size.width;

    return OnboardingScreenLayout(
      currentStep: 5,
      onPressed: () {
        context
            .read<OnboardingBloc>()
            .add(ContinueOnboarding(user: widget.state.user));
      },
      children: [
        CustomTextHeader(text: 'Describe Yourself'),
        CustomTextField(
          hint: 'ENTER YOUR BIO',
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
        CustomTextField(
          hint: 'ENTER YOUR JOB',
          onChanged: (value) {
            context.read<OnboardingBloc>().add(
                  UpdateUser(
                    user: widget.state.user.copyWith(jobTitle: value),
                  ),
                );
          },
        ),
        SizedBox(height: 50),
        CustomTextHeader(text: 'What Do You Like?'),
        ChipsChoice<String>.multiple(
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
          choiceStyle: C2ChipStyle.outlined(),
        ),
      ],
    );
  }
}
