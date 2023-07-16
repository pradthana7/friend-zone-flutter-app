import 'package:dating_app/cubits/signup/signup_cubit.dart';
import 'package:dating_app/widgets/custom_text_container.dart';
import 'package:dating_app/screen/onboarding/widgets/custom_text_field.dart';
import 'package:dating_app/screen/onboarding/widgets/custom_text_header.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../widgets/custom_button.dart';

class Email extends StatelessWidget {
  final TabController tabController;

  const Email({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return BlocBuilder<SignupCubit, SignupState>(builder: (context, state) {
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  CustomTextHeader(
                      
                      text: 'What\'s Your Email Address?'),
                  CustomTextField(
                    hint: 'ENTER YOUR EMAIL',
                    onChanged: (value) {
                      context.read<SignupCubit>().emailChanged(value);
                      print(state.email);
                    },
                  ),
                  SizedBox(height: 100),
                  CustomTextHeader(
                       text: 'Set Your Password'),
                  CustomTextField(
                    hint: 'Password should be at least 6 characters',
                    onChanged: (value) {
                      context.read<SignupCubit>().passwordChanged(value);
                      print(state.password);
                    },
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    StepProgressIndicator(
                      totalSteps: 6,
                      currentStep: 1,
                      selectedColor: Theme.of(context).primaryColor,
                      unselectedColor: Theme.of(context).disabledColor,
                    ),
                    SizedBox(height: 10),
                    CustomButtom(
                      tabController: tabController,
                      text: 'NEXT',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      
    });
  }
}
