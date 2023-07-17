import 'package:dating_app/screen/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../screens.dart';
import '/blocs/blocs.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import '/screen/onboarding/widgets/widgets.dart';

class Location extends StatelessWidget {
  const Location({
    Key? key,
    required this.state,
  }) : super(key: key);

  final OnboardingLoaded state;

  @override
  Widget build(BuildContext context) {
    return OnboardingScreenLayout(
      currentStep: 6,
      onPressed: () {
        Navigator.pushNamed(context, HomeScreen.routeName);
      },
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextHeader(text: 'Where Are You?'),
            CustomTextField(
              hint: 'ENTER YOUR LOCATION',
              onChanged: (value) {
                context.read<OnboardingBloc>().add(
                      UpdateUser(
                        user: state.user.copyWith(location: value),
                      ),
                    );
              },
            ),
          ],
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
    //         children: [
    //           StepProgressIndicator(
    //             totalSteps: 6,
    //             currentStep: 6,
    //             selectedColor: Theme.of(context).primaryColor,
    //             unselectedColor: Theme.of(context).backgroundColor,
    //           ),
    //           SizedBox(height: 10),
    //           CustomButton(
    //             text: 'DONE',

    //           )
    //         ],
    //       ),
    //     ],
    //   ),
    // );
  }
}
