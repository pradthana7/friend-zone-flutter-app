import 'package:dating_app/blocs/blocs.dart';
import 'package:dating_app/repositories/repositories.dart';
import 'package:dating_app/screen/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/match/match_bloc.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';

class MatchesScreen extends StatelessWidget {
  static const String routeName = '/matches';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => BlocProvider<MatchBloc>(
          create: (context) => MatchBloc(
                databaseRepository: context.read<DatabaseRepository>(),
              )..add(
                  LoadMatches(user: context.read<AuthBloc>().state.user!),
                ),
          child: MatchesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'MATCHES'),
      body: BlocBuilder<MatchBloc, MatchState>(
        builder: (context, state) {
          if (state is MatchLoading) {
            print('state is MatchLoading');
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is MatchLoaded) {
            print('state is MatchLoaded');
            final inactiveMatches = state.matches
                .where((match) => match.chat.messages.isEmpty)
                .toList();
            final activeMatches = state.matches
                .where((match) => match.chat.messages.isNotEmpty)
                .toList();
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NEW MATCHES',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    inactiveMatches.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              'Go back to swiping',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ))
                        : MatchesList(inactiveMatches: inactiveMatches),
                    Text(
                      'MESSAGES',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    ChatsList(activeMatches: activeMatches)
                  ],
                ),
              ),
            );
          }
          if (state is MatchUnavailable) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'No Matches Yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  CustomElevatedButton(
                    text: 'Back To Swiping',
                    beginColor: Color.fromARGB(255, 115, 211, 144),
                    endColor: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Text('Something went wrong'),
            );
          }
        },
      ),
    );
  }
}

class ChatsList extends StatelessWidget {
  const ChatsList({
    super.key,
    required this.activeMatches,
  });

  final List<Match> activeMatches;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: activeMatches.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                ChatScreen.routeName,
                arguments: activeMatches[index],
              );
            },
            child: Row(
              children: [
                UserImage.small(
                  margin: const EdgeInsets.only(top: 10, right: 10),
                  height: 70,
                  width: 70,
                  url: activeMatches[index].matchUser.imageUrls[0],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activeMatches[index].matchUser.name,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      activeMatches[index].chat.messages[0].message,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      activeMatches[index].chat.messages[0].timeString,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}

class MatchesList extends StatelessWidget {
  const MatchesList({
    super.key,
    required this.inactiveMatches,
  });

  final List<Match> inactiveMatches;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: inactiveMatches.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  ChatScreen.routeName,
                  arguments: inactiveMatches[index],
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 10, right: 10),
                child: Column(
                  children: [
                    UserImage.small(
                      height: 70,
                      width: 70,
                      url: inactiveMatches[index].matchUser.imageUrls[0],
                    ),
                    Text(
                      inactiveMatches[index].matchUser.name,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
