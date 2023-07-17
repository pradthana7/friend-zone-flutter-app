import 'package:dating_app/blocs/onboarding/onboarding_bloc.dart';
import 'package:dating_app/cubits/signup/signup_cubit.dart';
import 'package:dating_app/screen/onboarding/onboarding_screen.dart';

import 'package:dating_app/screen/onboarding/widgets/custom_text_field.dart';
import 'package:dating_app/screen/onboarding/widgets/custom_text_header.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';

import '../../../models/models.dart';
import '../widgets/custom_button.dart';

class Email extends StatelessWidget {
  const Email({
    Key? key,
    required this.state,
  }) : super(key: key);

  final OnboardingLoaded state;

  @override
  Widget build(BuildContext context) {
    return OnboardingScreenLayout(
      currentStep: 2,
      onPressed:    () async {
                    await context.read<SignupCubit>().signUpWithCredentials();
                    context.read<OnboardingBloc>().add(
                          ContinueOnboarding(
                            isSignup: true,
                            user:
                                User.empty.copyWith(
                                  id: context.read<SignupCubit>().state.user!.uid,
                                ),
                          ),
                        );
                  },
      children: [
        CustomTextHeader(text: 'What\'s Your Email Address?'),
              CustomTextField(
                hint: 'ENTER YOUR EMAIL',
                onChanged: (value) {
                  context.read<SignupCubit>().emailChanged(value);
                },
              ),
              SizedBox(height: 100),
              CustomTextHeader(text: 'Set Your Password'),
              CustomTextField(
                hint: 'Password should be at least 6 characters',
                onChanged: (value) {
                  context.read<SignupCubit>().passwordChanged(value);
                },
              ),
      ],
    );
    //  Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       Column(
    //         children: [
              
    //         ],
    //       ),
    //       Align(
    //         alignment: Alignment.bottomCenter,
    //         child: Column(
    //           children: [
    //             StepProgressIndicator(
    //               totalSteps: 6,
    //               currentStep: 1,
    //               selectedColor: Theme.of(context).primaryColor,
    //               unselectedColor: Theme.of(context).disabledColor,
    //             ),
    //             SizedBox(height: 10),
    //             CustomButton(
    //               text: 'NEXT',
    //               onPressed: 
 
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
