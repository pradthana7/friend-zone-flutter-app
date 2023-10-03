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
              hintText: 'example@me.com',maxLines: 1,
              errorText: state.email.invalid ? 'The email is invalid.' : null,
              onChanged: (value) {
                context.read<SignupCubit>().emailChanged(value);
              },
            );
          },
        ),
        const SizedBox(height: 50.0),
        const CustomTextHeader(text: 'Set your password'),
        const SizedBox(height: 20.0),
        BlocBuilder<SignupCubit, SignupState>(
          buildWhen: (previous, current) =>
              previous.password != current.password,
          builder: (context, state) {
            return CustomTextField(
              hintText: 'p@ssw0rd123',maxLines: 1,
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
            SnackBar(
              content: Text('Check your email or password'),
            ),
          );
        }
      }, 
    );
  }
}
