import 'package:dating_app/blocs/onboarding/onboarding_bloc.dart';
import 'package:dating_app/screen/onboarding/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class Start extends StatelessWidget {
  const Start({
    Key? key,
    required this.state,
  }) : super(key: key);

  final OnboardingLoaded state;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 300,
          width: 300,
          child: SvgPicture.asset('assets/threefriends.svg'),
        ),
        Text(
          'Welcome To Friend Zone',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 10),
        Expanded(
          child: Text(
            'The correct answer to any question must be based on something that was written in the text or heard in the audio recording.The correct answer to any question must be based on something that was written in the text or heard in the audio recording.',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(height: 1.5),
          ),
        ),
        SizedBox(height: 10),
        CustomButton(
          text: 'START',
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
