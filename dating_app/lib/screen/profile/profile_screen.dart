import 'package:chips_choice/chips_choice.dart';

import 'package:dating_app/repositories/auth/auth_repository.dart';
import 'package:dating_app/repositories/database/database_repository.dart';

import 'package:dating_app/screen/onboarding/widgets/custom_text_field.dart';
import 'package:dating_app/screen/screens.dart';

import 'package:dating_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) {
        print(BlocProvider.of<AuthBloc>(context).state.status);
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
                child: ProfileScreen(),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'PROFILE',
        actioinsIcons: [
          Icons.message,
          Icons.settings,
        ],
        actionsRoutes: [
          MatchesScreen.routeName,
          SettingsScreen.routeName,
        ],
      ),
      body: SingleChildScrollView(
        child:
            BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
          if (state is ProfileLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ProfileLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                UserImage.medium(
                  url: state.user
                      .imageUrls[0], //it'll be error when it has no a pic(s)
                  child: Container(
                    height: MediaQuery.of(context).size.height / 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor.withOpacity(0.1),
                          Theme.of(context).primaryColor.withOpacity(0.9),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 40),
                        child: Text(
                          state.user.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CustomElevatedButton(
                        text: 'View',
                        beginColor: state.isEditingOn
                            ? Colors.white
                            : Colors.lightBlueAccent,
                        endColor: state.isEditingOn
                            ? Colors.white
                            : Colors.pinkAccent,
                        textColor:
                            state.isEditingOn ? Colors.blue : Colors.white,
                        width: MediaQuery.of(context).size.width * 0.45,
                        onPressed: () {
                          context.read<ProfileBloc>().add(
                                SaveProfile(
                                  user: state.user,
                                ),
                              );
                        },
                      ),
                      SizedBox(width: 10),
                      CustomElevatedButton(
                        text: 'Edit',
                        beginColor: state.isEditingOn
                            ? Colors.lightBlueAccent
                            : Colors.white,
                        endColor: state.isEditingOn
                            ? Colors.pinkAccent
                            : Colors.white,
                        textColor:
                            state.isEditingOn ? Colors.white : Colors.blue,
                        width: MediaQuery.of(context).size.width * 0.45,
                        onPressed: () {
                          context.read<ProfileBloc>().add(
                                EditProfile(
                                  isEditingOn: true,
                                ),
                              );
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TextField(
                        title: 'Biography',
                        value: state.user.bio,
                        onchanged: (value) {
                          context.read<ProfileBloc>().add(
                                UpdateUserProfile(
                                  user: state.user.copyWith(bio: value),
                                ),
                              );
                        },
                      ),
                      _TextField(
                        title: 'Age',
                        value: '${state.user.age}',
                        onchanged: (value) {
                          if (value == null) {
                            return;
                          }
                          if (value == '') {
                            return;
                          }

                          context.read<ProfileBloc>().add(
                                UpdateUserProfile(
                                  user: state.user.copyWith(
                                    age: int.parse(value),
                                  ),
                                ),
                              );
                        },
                      ),
                      _TextField(
                        title: 'Job Title',
                        value: state.user.jobTitle,
                        onchanged: (value) {
                          context.read<ProfileBloc>().add(
                                UpdateUserProfile(
                                  user: state.user.copyWith(jobTitle: value),
                                ),
                              );
                        },
                      ),
                      _Pictures(),
                      _Interests(),
                      _SignOut(),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Text('Something went wrong');
          }
        }),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  final String title;
  final String value;
  final Function(String?) onchanged;

  const _TextField({
    Key? key,
    required this.title,
    required this.value,
    required this.onchanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      state as ProfileLoaded;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 8),
          state.isEditingOn
              ? CustomTextField(
                  initialValue: value,
                  onChanged: onchanged,
                )
              : Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        height: 1,
                      ),
                ),
          SizedBox(height: 10),
        ],
      );
    });
  }
}

class _Pictures extends StatelessWidget {
  const _Pictures({
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
              'Pictures',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: state.user.imageUrls.length > 0 ? 125 : 0,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: state.user.imageUrls.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: UserImage.small(
                      width: 100,
                      url: state.user.imageUrls[index],
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Interests extends StatelessWidget {
  const _Interests({
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
            Text(
              'Interests',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 10),
            Container(
              
              width: double.infinity, // Set a maximum width for ChipsChoice
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  state.isEditingOn
                      ? ChipsChoice<dynamic>.multiple(
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
                          choiceStyle: C2ChipStyle.outlined(),
                        )
                      : Container(
                          // Wrap Wrap in a Container to ensure it's a Widget
                          
                          child: Wrap(
                            spacing: 6.0,
                            runSpacing: 0.0,
                            children: state.user.interests.map((interest) {
                              return Chip(
                                label: Text(interest),
                              );
                            }).toList(),
                          ),
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

class _SignOut extends StatelessWidget {
  const _SignOut({
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
            TextButton(
              onPressed: () {
                RepositoryProvider.of<AuthRepository>(context).signOut();
              },
              child: Center(
                child: Text(
                  'Sign Out',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: Theme.of(context).primaryColor),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
