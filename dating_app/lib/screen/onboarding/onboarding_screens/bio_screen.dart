import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../screens.dart';
import '/screen/onboarding/widgets/widgets.dart';
import '/blocs/blocs.dart';

class Bio extends StatelessWidget {
  Bio({
    Key? key,
    required this.state,
  }) : super(key: key);

  final OnboardingLoaded state;

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
  ];

  @override
  Widget build(BuildContext context) {
    return OnboardingScreenLayout(
      currentStep: 5,
      onPressed: () {
        context
            .read<OnboardingBloc>()
            .add(ContinueOnboarding(user: state.user));
      },
      children: [
        CustomTextHeader(text: 'Describe Yourself'),
        CustomTextField(
          hint: 'ENTER YOUR BIO',
          onChanged: (value) {
            context.read<OnboardingBloc>().add(
                  UpdateUser(
                    user: state.user.copyWith(bio: value),
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
                    user: state.user.copyWith(jobTitle: value),
                  ),
                );
          },
        ),
        SizedBox(height: 50),
        CustomTextHeader(text: 'What Do You Like?'),
        Container(
          height: 500, // Set a fixed height to limit scrollable area
          child: GridView.builder(
            // Disable scrolling
          physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 0.3,
              childAspectRatio: 1.7, // Adjust this value to control item size
            ),
            itemCount: interests.length,
            itemBuilder: (context, index) {
              return CustomTextContainer(text: interests[index]);
            },
          ),
        ),
      ],
    );
    //  Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     mainAxisSize: MainAxisSize.max,
    //     children: [
    //       Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [

    //           SizedBox(height: 20),
    //         ],
    //       ),
    //       Align(
    //         alignment: Alignment.bottomCenter,
    //         child: Column(
    //           children: [
    //             StepProgressIndicator(
    //               totalSteps: 6,
    //               currentStep: 5,
    //               selectedColor: Theme.of(context).primaryColor,
    //               unselectedColor: Theme.of(context).backgroundColor,
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
