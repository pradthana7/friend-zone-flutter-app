import 'package:dating_app/blocs/auth/auth_bloc.dart';
import 'package:dating_app/blocs/swipe/swipe_bloc.dart';
import 'package:dating_app/models/models.dart';
import 'package:dating_app/screen/matches/matches_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/repositories.dart';
import '../../widgets/widgets.dart';
import '../login/login_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) {
        print(BlocProvider.of<AuthBloc>(context).state.status);
        return BlocProvider.of<AuthBloc>(context).state.status ==
                AuthStatus.unauthenticated
            ? LoginScreen()
            : BlocProvider<SwipeBloc>(
                create: (context) => SwipeBloc(
                  authBloc: context.read<AuthBloc>(),
                  databaseRepository: context.read<DatabaseRepository>(),
                )..add(LoadUsers()),
                child: HomeScreen(),
              );
      },
    );
  }

  Widget build(BuildContext context) {
    return BlocBuilder<SwipeBloc, SwipeState>(
      builder: (context, state) {
        if (state is SwipeLoading) {
          print('state is SwipeLoading');
          return Scaffold(
            appBar: CustomAppBar(title: 'F-R-I-E-N-D-S'),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is SwipeLoaded) {
          return SwipeLoadedHomeScreen(state: state);
        }
        if (state is SwipeMatched) {
          return SwipeMatchedHomeScreen(state: state);
        }
        if (state is SwipeError) {
          return Scaffold(
            appBar: CustomAppBar(title: 'F-R-I-E-N-D-S'),
            body: Center(
              child: Align(
                child: Center(
                  child: Text(
                    'There aren\'t any more users.',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: CustomAppBar(title: 'F-R-I-E-N-D-S'),
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
      appBar: CustomAppBar(title: 'F-R-I-E-N-D-S'),
      body: Column(
        children: [
          InkWell(
            onDoubleTap: () {
              Navigator.pushNamed(context, '/users', arguments: state.users[0]);
            },
            child: Draggable<User>(
              data: state.users[0],
              child: UserCard(user: state.users[0]),
              feedback: UserCard(user: state.users[0]),
              childWhenDragging: (userCount > 1)
                  ? UserCard(user: state.users[1])
                  : Container(),
              onDragEnd: (drag) {
                if (drag.velocity.pixelsPerSecond.dx < 0) {
                  context.read<SwipeBloc>()
                    ..add(SwipeLeft(user: state.users[0]));
                  print('Swiped Left');
                } else {
                  context.read<SwipeBloc>()
                    ..add(SwipeRight(user: state.users[0]));
                  print('Swiped Right');
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    context.read<SwipeBloc>()
                      ..add(SwipeLeft(user: state.users[0]));
                  },
                  child: ChoiceButton(
                    color: Colors.red.shade300,
                    icon: Icons.clear,
                  ),
                ),
                InkWell(
                  onTap: () {
                    context.read<SwipeBloc>()
                      ..add(SwipeRight(user: state.users[0]));
                  },
                  child: ChoiceButton(
                    width: 70,
                    height: 70,
                    size: 30,
                    hasGradient: true,
                    color: Color.fromARGB(255, 255, 255, 255),
                    icon: Icons.favorite_outlined,
                  ),
                ),
                ChoiceButton(
                  color: Colors.grey.shade700,
                  icon: Icons.watch_later,
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
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            Text(
              'You and ${state.user.name} have liked each other!',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
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
                          Color.fromARGB(255, 225, 116, 152),
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
                          Color.fromARGB(255, 115, 211, 144),
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
              text: 'Send a Message',
              beginColor: Colors.white,
              endColor: Colors.white,
              textColor: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.pushNamed(context, MatchesScreen.routeName);
              },
            ),
            const SizedBox(height: 10),
            CustomElevatedButton(
              text: 'Back To Swiping',
              beginColor: Theme.of(context).primaryColor,
              endColor: Color.fromARGB(255, 115, 211, 144),
              textColor: Colors.white,
              onPressed: () {
                context.read<SwipeBloc>().add(LoadUsers());
              },
            ),
          ],
        ),
      ),
    );
  }
}
