import 'package:dating_app/blocs/blocs.dart';
import 'package:dating_app/repositories/repositories.dart';
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
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is MatchLoaded) {
            final inactiveMatches =
                state.matches.where((match) => match.chat == null).toList();
            final activeMatches =
                state.matches.where((match) => match.chat != null).toList();
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Liked',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    MatchesList(inactiveMatches: inactiveMatches),
                    SizedBox(height: 20),
                    Text(
                      'Messages',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    ChatsList(activeMatches: activeMatches)
                  ],
                ),
              ),
            );
          }
          if (state is MatchUnavailable) {
            return Column(
              children: [
                Text(
                  'No Matches Yet',
                  style: Theme.of(context).textTheme.headlineMedium,
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
              Navigator.pushNamed(context, '/chat',
                  arguments: activeMatches[index]);
            },
            child: Row(
              children: [
                UserImage.small(
                  margin: const EdgeInsets.only(top: 10, right: 10),
                  height: 70,
                  width: 70,
                  url: activeMatches[index].matchedUser.imageUrls[0],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activeMatches[index].matchedUser.name,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    SizedBox(height: 5),
                    Text(
                      activeMatches[index].chat![0].messages[0].message,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(height: 5),
                    Text(
                      activeMatches[index].chat![0].messages[0].timeString,
                      style: Theme.of(context).textTheme.bodyText1,
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
            return Column(
              children: [
                UserImage.small(
                  margin: const EdgeInsets.only(top: 10, right: 10),
                  height: 70,
                  width: 70,
                  url: inactiveMatches[index].matchedUser.imageUrls[0],
                ),
                Text(
                  inactiveMatches[index].matchedUser.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            );
          }),
    );
  }
}
