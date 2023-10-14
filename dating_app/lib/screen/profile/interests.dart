import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';

class Interests extends StatelessWidget {
  const Interests({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        state as ProfileLoaded;

        List<String> interests = [
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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.interests_rounded),
                const SizedBox(width: 8),
                Text(
                  'Interests',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      
                      fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: double.infinity, // Set a maximum width for ChipsChoice
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  state.isEditingOn
                      ? ChipsChoice<dynamic>.multiple(
                          wrapped: true,
                          value: state.user.interests,
                          onChanged: (val) {
                            context.read<ProfileBloc>().add(
                                  UpdateUserProfile(
                                    user: state.user.copyWith(interests: val),
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
                          choiceStyle: C2ChipStyle(
                            checkmarkColor: Colors.red.shade400,
                            backgroundColor: Colors.red,
                            checkmarkWeight: 1.5,
                          ),
                        )
                      : Wrap(
                        spacing: 5.0,
                        runSpacing: -5.0,
                        children: state.user.interests.map((interest) {
                          return Chip(
                            label: Text(interest),
                          );
                        }).toList(),
                      ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
