import 'package:dating_app/blocs/auth/auth_bloc.dart';

import 'package:dating_app/repositories/auth/auth_repository.dart';
import 'package:dating_app/repositories/database/database_repository.dart';
import 'package:dating_app/screen/login/login_screen.dart';
import 'package:dating_app/screen/matches/matches_screen.dart';
import 'package:dating_app/screen/onboarding/onboarding_screen.dart';
import 'package:dating_app/screen/onboarding/widgets/custom_text_field.dart';
import 'package:dating_app/screen/screens.dart';
import 'package:dating_app/widgets/custom_appbar.dart';
import 'package:dating_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';
import '../../models/user_model.dart';

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
                        beginColor:
                            state.isEditingOn ? Colors.white : Colors.blue,
                        endColor:
                            state.isEditingOn ? Colors.white : Colors.pink,
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
                        beginColor:
                            state.isEditingOn ? Colors.white : Colors.blue,
                        endColor:
                            state.isEditingOn ? Colors.white : Colors.pink,
                        textColor:
                            state.isEditingOn ? Colors.blue : Colors.white,
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
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 10),
          state.isEditingOn
              ? CustomTextField(
                  initialValue: value,
                  onChanged: onchanged,
                )
              : Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        height: 1.5,
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
              style: Theme.of(context).textTheme.headline3,
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Interest',
              style: Theme.of(context).textTheme.headline3,
            ),
            Row(
              children: [
                CustomTextContainer(text: 'MUSIC'),
                CustomTextContainer(text: 'ECONOMICS'),
                CustomTextContainer(text: 'FOOTBALL'),
              ],
            ),
            SizedBox(height: 10),
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
                      .headline5!
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
