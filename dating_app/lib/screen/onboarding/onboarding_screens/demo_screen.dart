import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../screens.dart';
import '/blocs/blocs.dart';
import '/screen/onboarding/widgets/widgets.dart';

class Demo extends StatefulWidget {
  const Demo({
    Key? key,
    required this.state,
  }) : super(key: key);

  final OnboardingLoaded state;

  @override
  DemoState createState() => DemoState();
}

class DemoState extends State<Demo> {
  bool isCheckboxSelected = false; // Keep track of checkbox selection
  bool isAgeValid = false; // Keep track of age validation

  @override
  Widget build(BuildContext context) {
    return OnboardingScreenLayout(
      currentStep: 3,
      onPressed: isCheckboxSelected &&
              isAgeValid // Disable button if checkbox or age is not valid
          ? () {
              context
                  .read<OnboardingBloc>()
                  .add(ContinueOnboarding(user: widget.state.user));
            }
          : null, // Set to null to disable the button

      children: [
        const CustomTextHeader(text: 'What\'s Your Name?'),
        const SizedBox(height: 20),
        CustomTextField(
          hintText: 'enter your name',
          onChanged: (value) {
            context.read<OnboardingBloc>().add(
                  UpdateUser(
                    user: widget.state.user.copyWith(name: value),
                  ),
                );
          },
        ),
        const SizedBox(height: 50),
        CustomCheckbox(
          text: 'Male',
          value: widget.state.user.gender == 'Male',
          onChanged: (bool? newValue) {
            context.read<OnboardingBloc>().add(
                  UpdateUser(
                    user: widget.state.user.copyWith(gender: 'Male'),
                  ),
                );
            setState(() {
              isCheckboxSelected = true; // Update the checkbox selection status
            });
          },
        ),
        CustomCheckbox(
          text: 'Female',
          value: widget.state.user.gender == 'Female',
          onChanged: (bool? newValue) {
            context.read<OnboardingBloc>().add(
                  UpdateUser(
                    user: widget.state.user.copyWith(gender: 'Female'),
                  ),
                );
            setState(() {
              isCheckboxSelected = true; // Update the checkbox selection status
            });
          },
        ),
        CustomCheckbox(
          text: 'Rather not say',
          value: widget.state.user.gender == 'Other',
          onChanged: (bool? newValue) {
            context.read<OnboardingBloc>().add(
                  UpdateUser(
                    user: widget.state.user.copyWith(gender: 'Other'),
                  ),
                );
            setState(() {
              isCheckboxSelected = true; // Update the checkbox selection status
            });
          },
        ),
        const SizedBox(height: 50),
        const CustomTextHeader(text: 'How old are you?'),
        const SizedBox(height: 20.0),
        CustomTextField(
          hintText: '18-100',
          onChanged: (value) {
            context.read<OnboardingBloc>().add(
                  UpdateUser(
                    user: widget.state.user.copyWith(age: int.parse(value)),
                  ),
                );
            setState(() {
              isAgeValid = int.tryParse(value) != null &&
                  int.parse(value) >=
                      18; // Update the age validation status with a null check
            });
          },
        ),
      ],
    );
  }
}
