import 'package:dating_app/repositories/database/database_repository.dart';

import 'package:dating_app/screen/onboarding/widgets/custom_text_field.dart';
import 'package:dating_app/screen/screens.dart';
import 'package:dating_app/widgets/loading_indicator.dart';

import 'package:dating_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';

import '../../widgets/full_image.dart';
import '../profile/logout.dart';
import 'interests.dart';

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
      appBar: const CustomAppBar(
        title: 'Profile',
        actioinsIcons: [
          Icons.chat_bubble_outline_rounded,
          Icons.filter_center_focus,
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
              child: LoadingIndicator(),
            );
          }

          if (state is ProfileLoaded) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .5,
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 40.0),
                                child: Container(
                                  height: MediaQuery.of(context).size.height,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.elliptical(
                                          MediaQuery.of(context).size.width *
                                              0.5,
                                          100.0),
                                      bottomRight: Radius.elliptical(
                                          MediaQuery.of(context).size.width *
                                              0.5,
                                          100.0),
                                    ),
                                    image: DecorationImage(
                                      colorFilter: const ColorFilter.mode(
                                          Colors.black38, BlendMode.darken),
                                      fit: BoxFit.cover,
                                      image:
                                          NetworkImage(state.user.imageUrls[0]),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Stack(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          left: 10, top: 10),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 10),
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Text(
                                          state.user.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: const Color(0xffD8D8D8),
                                      child: IconButton(
                                        onPressed: () {
                                          context.read<ProfileBloc>().add(
                                                SaveProfile(
                                                  user: state.user,
                                                ),
                                              );
                                        },
                                        icon: const Icon(Icons.save_rounded),
                                        color: const Color(0xff6E6E6E),
                                      ),
                                    ),
                                    CircleAvatar(
                                      radius: 70,
                                      backgroundImage:
                                          NetworkImage(state.user.imageUrls[0]),
                                    ),
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: const Color(0xffD8D8D8),
                                      child: IconButton(
                                        onPressed: () {
                                          context.read<ProfileBloc>().add(
                                                const EditProfile(
                                                  isEditingOn: true,
                                                ),
                                              );
                                        },
                                        icon: const Icon(
                                            Icons.mode_edit_outline_outlined),
                                        color: const Color(0xff6E6E6E),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TextField(
                        title: 'About Me',
                        value: state.user.bio,
                        onchanged: (value) {
                          context.read<ProfileBloc>().add(
                                UpdateUserProfile(
                                  user: state.user.copyWith(bio: value),
                                ),
                              );
                        },
                        icon: const Icon(Icons.add_reaction_outlined),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Personal Info',
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      _TextField(
                        title: 'Display Name',
                        value: state.user.name,
                        onchanged: (value) {
                          context.read<ProfileBloc>().add(
                                UpdateUserProfile(
                                  user: state.user.copyWith(name: value),
                                ),
                              );
                        },
                        icon: const Icon(Icons.abc_outlined),
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
                        icon: const Icon(Icons.emoji_nature_outlined),
                      ),
                      _TextField(
                        title: 'Job',
                        value: state.user.jobTitle,
                        onchanged: (value) {
                          context.read<ProfileBloc>().add(
                                UpdateUserProfile(
                                  user: state.user.copyWith(jobTitle: value),
                                ),
                              );
                        },
                        icon: const Icon(Icons.work_outline_rounded),
                      ),
                      const _Pictures(),
                      const Interests(),
                      const SignOut(),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Text('Something went wrong');
          }
        }),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  final String title;
  final String value;
  final Icon icon;
  final Function(String?) onchanged;

  const _TextField({
    Key? key,
    required this.title,
    required this.value,
    required this.onchanged,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      state as ProfileLoaded;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              icon, // Icon
              const SizedBox(width: 8), // Add spacing between icon and text
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          SizedBox(height: 8),
          state.isEditingOn
              ? CustomTextField(
                  initialValue: value,
                  onChanged: onchanged,
                )
              : Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 0,
                    bottom: 0,
                  ),
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 18,
                        ),
                  ),
                ),
          const SizedBox(height: 18),
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
            Row(
              children: [
                Icon(Icons.insert_photo_outlined),
                SizedBox(width: 8),
                Text(
                  'Pictures',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 18),
              height: state.user.imageUrls.isNotEmpty ? 120 : 0,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: state.user.imageUrls.length,
                itemBuilder: (context, index) {
                  final tag = 'image_$index';
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OpenFullImage(
                            context: context,
                            imageUrl: state.user.imageUrls[index],
                            tag: tag,
                          ),
                        ),
                      );
                    },
                    child: Hero(
                      tag: tag,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: UserImage.small(
                          width: 100,
                          url: state.user.imageUrls[index],
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
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
