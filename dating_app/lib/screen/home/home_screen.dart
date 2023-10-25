import 'package:dating_app/blocs/auth/auth_bloc.dart';
import 'package:dating_app/blocs/swipe/swipe_bloc.dart';
import 'package:dating_app/models/models.dart';

import 'package:dating_app/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/repositories.dart';
import '../../widgets/widgets.dart';

import '../screens.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/';

  const HomeScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        // print(BlocProvider.of<AuthBloc>(context).state.status);
        return BlocProvider.of<AuthBloc>(context).state.status ==
                AuthStatus.unauthenticated
            ? const LoginScreen()
            : BlocProvider<SwipeBloc>(
                create: (context) => SwipeBloc(
                  authBloc: context.read<AuthBloc>(),
                  databaseRepository: context.read<DatabaseRepository>(),
                )..add(LoadUsers()),
                child: const HomeScreen(),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SwipeBloc, SwipeState>(
      builder: (context, state) {
        if (state is SwipeLoading) {
          // print('state is SwipeLoading');
          return const Scaffold(
            appBar: CustomAppBar(title: 'Hey Guys!'),
            body: Center(
              child: LoadingIndicator(),
            ),
          );
        }
        if (state is SwipeLoaded) {
          // print('state is SwipeLoaded');
          return SwipeLoadedHomeScreen(state: state);
        }
        if (state is SwipeMatched) {
          // print('state is SwipeMatched');
          return SwipeMatchedHomeScreen(state: state);
        }
        if (state is SwipeError) {
          return Scaffold(
            appBar: const CustomAppBar(title: 'Hey Guys!'),
            body: Center(
              child: Align(
                child: Center(
                  child: Text(
                    'No new profiles matching your filters🔎.',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Scaffold(
            appBar: CustomAppBar(title: 'Hey Guys!'),
            body: Center(
              child: Text('Something went wrong.'),
            ),
          );
        }
      },
    );
  }
}

class SwipeLoadedHomeScreen extends StatelessWidget {
  const SwipeLoadedHomeScreen({
    Key? key,
    required this.state,
  }) : super(key: key);

  final SwipeLoaded state;

  @override
  Widget build(BuildContext context) {
    var userCount = state.users.length;
    return Scaffold(
      appBar: const CustomAppBar(title: 'Hey Guys!'),
      body: Column(
        children: [
          InkWell(
            onDoubleTap: () {
              Navigator.pushNamed(context, '/users', arguments: state.users[0]);
            },
            child: Draggable<User>(
              data: state.users[0],
              feedback: UserCard(user: state.users[0]),
              childWhenDragging: (userCount > 1)
                  ? UserCard(user: state.users[1])
                  : Container(),
              onDragEnd: (drag) {
                if (drag.velocity.pixelsPerSecond.dx < 0) {
                  context
                      .read<SwipeBloc>()
                      .add(SwipeLeft(user: state.users[0]));
                  // print('Swiped Left');
                } else if (drag.velocity.pixelsPerSecond.dx > 0) {
                  context
                      .read<SwipeBloc>()
                      .add(SwipeRight(user: state.users[0]));
                  // print('Swiped Right');
                }
              },
              child: UserCard(user: state.users[0]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    context
                        .read<SwipeBloc>()
                        .add(SwipeLeft(user: state.users[0]));
                  },
                  child: const ChoiceButton(
                    color: Color(0xffff3300),
                    icon: Icons.thumb_down_alt_rounded,
                  ),
                ),
                InkWell(
                  onTap: () {
                    context
                        .read<SwipeBloc>()
                        .add(SwipeRight(user: state.users[0]));
                  },
                  child: const ChoiceButton(
                    hasGradient: false,
                    color: Color(0xff9a6600),
                    icon: Icons.thumb_up_off_alt_rounded,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SwipeMatchedHomeScreen extends StatelessWidget {
  const SwipeMatchedHomeScreen({
    Key? key,
    required this.state,
  }) : super(key: key);

  final SwipeMatched state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Congrats, it\'s a match!',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            Text(
              'You and ${state.user.name} have liked each other!',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color.fromARGB(255, 225, 116, 152),
                          Theme.of(context).primaryColor
                        ],
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage(
                          context.read<AuthBloc>().state.user!.imageUrls[0]),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ClipOval(
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.pink.shade300,
                          Theme.of(context).primaryColor
                        ],
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage(
                        state.user.imageUrls[0],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomElevatedButton(
              text: 'Send a Messsage',
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () {
                Navigator.pushNamed(context, MatchesScreen.routeName);
              },
              fontSize: 14,
            ),
            const SizedBox(height: 10),
            CustomElevatedButton(
              text: 'Back',
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () {
                context.read<SwipeBloc>().add(LoadUsers());
              },
              fontSize: 14,
            ),
          ],
        ),
      ),
    );
  }
}
