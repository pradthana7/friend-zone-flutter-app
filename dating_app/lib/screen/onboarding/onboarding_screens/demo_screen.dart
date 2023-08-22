import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

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
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  bool isCheckboxSelected = false; // Keep track of checkbox selection
  bool isAgeValid = false; // Keep track of age validation

  @override
  Widget build(BuildContext context) {
    return OnboardingScreenLayout(
      currentStep: 3,
      onPressed: isCheckboxSelected && isAgeValid // Disable button if checkbox or age is not valid
          ? () {
              context
                  .read<OnboardingBloc>()
                  .add(ContinueOnboarding(user: widget.state.user));
            }
          : null, // Set to null to disable the button
      children: [
        CustomTextHeader(text: 'What\'s Your Name?'),
         SizedBox(height: 20),
        CustomTextField(
          hint: 'ENTER YOUR NAME',
          onChanged: (value) {
            context.read<OnboardingBloc>().add(
                  UpdateUser(
                    user: widget.state.user.copyWith(name: value),
                  ),
                );
          },
        ),
        SizedBox(height: 50),
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
        SizedBox(height: 50),
        CustomTextHeader(text: 'What\'s Your Age?'),
        CustomTextField(
          hint: 'At least 18 years old',
          onChanged: (value) {
            context.read<OnboardingBloc>().add(
                  UpdateUser(
                    user: widget.state.user.copyWith(age: int.parse(value)),
                  ),
                );
            setState(() {
              isAgeValid = int.tryParse(value) != null && int.parse(value) >= 18; // Update the age validation status with a null check
            });
          },
        ),
      ],
    );
  }
}
