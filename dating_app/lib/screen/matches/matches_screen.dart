import 'package:dating_app/blocs/blocs.dart';
import 'package:dating_app/repositories/repositories.dart';
import 'package:dating_app/screen/chat/chat_screen.dart';
import 'package:dating_app/widgets/loading_indicator.dart';
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
      appBar: CustomAppBar(title: 'Matches'),
      body: BlocBuilder<MatchBloc, MatchState>(
        builder: (context, state) {
          if (state is MatchLoading) {
            print('state is MatchLoading');
            return Center(
              child: LoadingIndicator(),
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
                      'New Matches',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    inactiveMatches.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              'No New Matches Now!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ))
                        : MatchesList(inactiveMatches: inactiveMatches),
                    Text(
                      'Messages',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 10.0),
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
                    text: 'Back',
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    fontSize: 16,
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('Something Went Wrong'),
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
                CircleAvatar(
                  radius: 35, // Adjust the size as needed
                  backgroundImage: NetworkImage(activeMatches[index]
                      .matchUser
                      .imageUrls[0]), // Use your image URL here
                ),
                const SizedBox(
                    width:
                        16), // Add some spacing between the CircleAvatar and other widgets
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activeMatches[index].matchUser.name,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    // const SizedBox(height: 5),
                    Text(
                      activeMatches[index].chat.messages[0].message,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    // const SizedBox(height: 2),
                    Text(
                      activeMatches[index].chat.messages[0].timeString,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
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
                    CircleAvatar(
                      radius: 35, // Adjust the size as needed
                      backgroundImage: NetworkImage(inactiveMatches[index]
                          .matchUser
                          .imageUrls[0]), // Use your image URL here
                    ),
                    const SizedBox(
                        height:
                            5), // Add some spacing between the CircleAvatar and the Text widget
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
