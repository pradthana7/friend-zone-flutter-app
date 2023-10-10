import 'package:dating_app/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../login/login_screen.dart';
import '/blocs/blocs.dart';
import '/repositories/repositories.dart';
import '/screen/screens.dart';
import '/widgets/widgets.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = '/settings';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) {
        print(BlocProvider.of<AuthBloc>(context).state);

        return BlocProvider.of<AuthBloc>(context).state.status ==
                AuthStatus.unauthenticated
            ? LoginScreen()
            : BlocProvider<ProfileBloc>(
                create: (context) => ProfileBloc(
                  authBloc: BlocProvider.of<AuthBloc>(context),
                  databaseRepository: context.read<DatabaseRepository>(),
                )..add(
                    LoadProfile(
                        userId: context.read<AuthBloc>().state.authUser!.uid),
                  ),
                child: SettingsScreen(),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Filter'),
      body: SingleChildScrollView(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return Center(child: LoadingIndicator());
            }
            if (state is ProfileLoaded) {
              return const Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    _GenderPreference(),
                    SizedBox(height: 30),
                    _AgeRangePreference(),
                  ],
                ),
              );
            } else {
              return Text('Something went wrong.');
            }
          },
        ),
      ),
    );
  }
}

class _AgeRangePreference extends StatelessWidget {
  const _AgeRangePreference({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        state as ProfileLoaded;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Age',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            Row(
              children: [
                Expanded(
                  child: RangeSlider(
                    values: RangeValues(
                      state.user.ageRangePreference![0].toDouble(),
                      state.user.ageRangePreference![1].toDouble(),
                    ),
                    min: 18,
                    max: 100,
                    activeColor: Theme.of(context).primaryColor,
                    inactiveColor: Theme.of(context).primaryColorLight,
                    onChanged: (rangeValues) {
                      context.read<ProfileBloc>().add(
                            UpdateUserProfile(
                              user: state.user.copyWith(
                                ageRangePreference: [
                                  rangeValues.start.toInt(),
                                  rangeValues.end.toInt(),
                                ],
                              ),
                            ),
                          );
                    },
                    onChangeEnd: (RangeValues newRangeValues) {
                      print('Ended change on $newRangeValues');
                      context.read<ProfileBloc>().add(
                            SaveProfile(
                              user: state.user.copyWith(
                                ageRangePreference: [
                                  newRangeValues.start.toInt(),
                                  newRangeValues.end.toInt(),
                                ],
                              ),
                            ),
                          );
                    },
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: Text(
                    '${state.user.ageRangePreference![0]} - ${state.user.ageRangePreference![1]}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        );
      },
    );
  }
}

class _GenderPreference extends StatelessWidget {
  const _GenderPreference({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        state as ProfileLoaded;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gender Selections',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            Row(
              children: [
                Checkbox(
                  shape: const CircleBorder(),
                  value: state.user.genderPreference!.contains('Male'),
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (value) {
                    if (state.user.genderPreference!.contains('Male')) {
                      context.read<ProfileBloc>().add(
                            UpdateUserProfile(
                              user: state.user.copyWith(
                                genderPreference:
                                    List.from(state.user.genderPreference!)
                                      ..remove('Male'),
                              ),
                            ),
                          );
                      context.read<ProfileBloc>().add(
                            SaveProfile(user: state.user),
                          );
                    } else {
                      context.read<ProfileBloc>().add(
                            UpdateUserProfile(
                              user: state.user.copyWith(
                                genderPreference:
                                    List.from(state.user.genderPreference!)
                                      ..add('Male'),
                              ),
                            ),
                          );
                      context.read<ProfileBloc>().add(
                            SaveProfile(user: state.user),
                          );
                    }
                  },
                  visualDensity: VisualDensity.compact,
                ),
                Text(
                  'Man',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  shape: const CircleBorder(),
                  activeColor: Theme.of(context).primaryColor,
                  value: state.user.genderPreference!.contains('Female'),
                  onChanged: (value) {
                    if (state.user.genderPreference!.contains('Female')) {
                      context.read<ProfileBloc>().add(
                            UpdateUserProfile(
                              user: state.user.copyWith(
                                genderPreference:
                                    List.from(state.user.genderPreference!)
                                      ..remove('Female'),
                              ),
                            ),
                          );
                      context.read<ProfileBloc>().add(
                            SaveProfile(user: state.user),
                          );
                    } else {
                      context.read<ProfileBloc>().add(
                            UpdateUserProfile(
                              user: state.user.copyWith(
                                genderPreference:
                                    List.from(state.user.genderPreference!)
                                      ..add('Female'),
                              ),
                            ),
                          );
                      context.read<ProfileBloc>().add(
                            SaveProfile(user: state.user),
                          );
                    }
                  },
                  visualDensity: VisualDensity.compact,
                ),
                Text(
                  'Woman',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  shape: const CircleBorder(),
                  value: state.user.genderPreference!.contains('Other'),
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (value) {
                    if (state.user.genderPreference!.contains('Other')) {
                      context.read<ProfileBloc>().add(
                            UpdateUserProfile(
                              user: state.user.copyWith(
                                genderPreference:
                                    List.from(state.user.genderPreference!)
                                      ..remove('Other'),
                              ),
                            ),
                          );
                      context.read<ProfileBloc>().add(
                            SaveProfile(user: state.user),
                          );
                    } else {
                      context.read<ProfileBloc>().add(
                            UpdateUserProfile(
                              user: state.user.copyWith(
                                genderPreference:
                                    List.from(state.user.genderPreference!)
                                      ..add('Other'),
                              ),
                            ),
                          );
                      context.read<ProfileBloc>().add(
                            SaveProfile(user: state.user),
                          );
                    }
                  },
                  visualDensity: VisualDensity.compact,
                ),
                Text(
                  'Rather not say',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        );
      },
    );
  }
}
