import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '/blocs/blocs.dart';
import '/cubits/cubits.dart';
import '/models/models.dart';
import '/screen/onboarding/widgets/widgets.dart';
import '../onboarding_screen.dart';

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
      children: [
        const CustomTextHeader(text: 'Email'),
        const SizedBox(height: 20.0),
        BlocBuilder<SignupCubit, SignupState>(
          buildWhen: (previous, current) => previous.email != current.email,
          builder: (context, state) {
            return CustomTextField(
              hintText: 'b6000000@g.sut.ac.th',
              maxLines: 1,
              errorText: state.email.invalid ? 'The email is invalid.' : null,
              onChanged: (value) {
                context.read<SignupCubit>().emailChanged(value);
              },
            );
          },
        ),
        const SizedBox(height: 50.0),
        const Row(
          children: [
            CustomTextHeader(text: 'Set your password'),
            SizedBox(width: 8),
            Tooltip(
                message:
                    "1. 8-32 characters long \n2. Must include at least\n\t1 lowercase letter,\n\t1 uppercase letter,\n\t1 number,\n\tand 1 special character (!, #, %)\n3. No other characters allowed",
                child: Icon(Icons.info_outline_rounded)),
          ],
        ),
        const SizedBox(height: 20.0),
        BlocBuilder<SignupCubit, SignupState>(
          buildWhen: (previous, current) =>
              previous.password != current.password,
          builder: (context, state) {
            return CustomTextField(
              hintText: 'only allowed A-Za-z0-9!#%',
              maxLines: 1,
              errorText: state.password.invalid
                  ? 'The password must contain at least 8 characters.'
                  : null,
              onChanged: (value) {
                context.read<SignupCubit>().passwordChanged(value);
              },
            );
          },
        ),
      ],
      onPressed: () async {
        if (BlocProvider.of<SignupCubit>(context).state.status ==
            FormzStatus.valid) {
          await context.read<SignupCubit>().signUpWithCredentials();
          context.read<OnboardingBloc>().add(
                ContinueOnboarding(
                  isSignup: true,
                  user: User.empty.copyWith(
                    id: context.read<SignupCubit>().state.user!.uid,
                  ),
                ),
              );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Check your email or password'),
            ),
          );
        }
      },
    );
  }
}
