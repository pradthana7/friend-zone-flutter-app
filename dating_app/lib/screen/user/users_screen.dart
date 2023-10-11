import 'package:dating_app/blocs/swipe/swipe_bloc.dart';
import 'package:dating_app/widgets/loading_indicator.dart';

import 'package:dating_app/widgets/user_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dating_app/models/user_model.dart';
import '../../blocs/blocs.dart';
import '../../models/user_model.dart';
import '../../repositories/repositories.dart';
import '../../widgets/full_image.dart';
import '../../widgets/widgets.dart';

// class UsersScreen extends StatelessWidget {
//   static const String routeName = '/users';

//   static Route route({required User user}) {
//     return MaterialPageRoute(
//       settings: RouteSettings(name: routeName),
//       builder: (context) {
//         print(BlocProvider.of<AuthBloc>(context).state.status);
//         return BlocProvider<SwipeBloc>(
//           create: (context) => SwipeBloc(
//             authBloc: context.read<AuthBloc>(),
//             databaseRepository: context.read<DatabaseRepository>(),
//           )..add(LoadUsers()),
//           child: UsersScreen(user: user),
//         );
//       },
//     );
//   }

//   final User user;

//   const UsersScreen({
//     required this.user,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       extendBodyBehindAppBar: true,
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               height: MediaQuery.of(context).size.height / 1.9,
//               child: Stack(
//                 children: [
//                   Hero(
//                     tag: 'user_card',
//                     child: Padding(
//                       padding: const EdgeInsets.only(bottom: 45.0),
//                       child: UserImage.medium(
//                         url: user.imageUrls[0],
//                         height: MediaQuery.of(context).size.height * 0.5,
//                         width: double.infinity,
//                       ),
//                     ),
//                   ),
//                   InkWell(
//                     onDoubleTap: () {
//                       Navigator.pop(context);
//                     },
//                   ),
//                   Align(
//                     alignment: Alignment.bottomCenter,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 8.0,
//                         horizontal: 60,
//                       ),
//                       child: BlocBuilder<SwipeBloc, SwipeState>(
//                         builder: (context, state) {
//                           if (state is SwipeLoading) {
//                             return Center(
//                               child: LoadingIndicator(),
//                             );
//                           }
//                           if (state is SwipeLoaded) {
//                             return Text('𖤓☀️⋆⁺₊⋆ ☀︎ ⋆⁺₊⋆☾☼☾⋆｡𖦹 °✩⛅');
//                           } else {
//                             return Text('Something went wrong.');
//                           }
//                         },
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('${user.name} ${user.age}',
//                       style: Theme.of(context).textTheme.titleLarge),
//                   Text(
//                     user.jobTitle,
//                     style: Theme.of(context)
//                         .textTheme
//                         .bodyLarge!
//                         .copyWith(fontWeight: FontWeight.normal),
//                   ),
//                   SizedBox(height: 15),
//                   Text('About Me',
//                       style: Theme.of(context).textTheme.titleLarge),
//                   Text(user.bio,
//                       style: Theme.of(context)
//                           .textTheme
//                           .bodyLarge!
//                           .copyWith(height: 2)),
//                   SizedBox(height: 15),
//                   Text('Interests',
//                       style: Theme.of(context).textTheme.titleLarge),
//                   SizedBox(height: 10),
//                   Container(
//                     child: Wrap(
//                       spacing: 5.0,
//                       runSpacing: -5.0,
//                       children: user.interests.map((interest) {
//                         return Chip(
//                           label: Text(interest),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class UsersScreen extends StatelessWidget {
  static const String routeName = '/users';

  static Route route({required User user}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) {
        print(BlocProvider.of<AuthBloc>(context).state.status);
        return BlocProvider<SwipeBloc>(
          create: (context) => SwipeBloc(
            authBloc: context.read<AuthBloc>(),
            databaseRepository: context.read<DatabaseRepository>(),
          )..add(LoadUsers()),
          child: UsersScreen(user: user),
        );
      },
    );
  }

  final User user;

  const UsersScreen({
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.9,
              child: Stack(
                children: [
                  Hero(
                    tag: 'user_card',
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 45.0),
                      child: UserImage.medium(
                        url: user.imageUrls[0],
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  InkWell(
                    onDoubleTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 60,
                      ),
                      child: BlocBuilder<SwipeBloc, SwipeState>(
                        builder: (context, state) {
                          if (state is SwipeLoading) {
                            return Center(
                              child: LoadingIndicator(),
                            );
                          }
                          if (state is SwipeLoaded) {
                            return Text('𖤓☀️⋆⁺₊⋆ ☀︎ ⋆⁺₊⋆☾☼☾⋆｡𖦹 °✩⛅');
                          } else {
                            return Text('Something went wrong.');
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${user.name} ${user.age}',
                      style: Theme.of(context).textTheme.titleLarge),
                  Text(
                    user.jobTitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.normal),
                  ),
                  SizedBox(height: 15),
                  Text('About Me',
                      style: Theme.of(context).textTheme.titleLarge),
                  Text(user.bio,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(height: 2)),
                  SizedBox(height: 15),
                  Text('Interests',
                      style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: 10),
                  Container(
                    child: Wrap(
                      spacing: 5.0,
                      runSpacing: -5.0,
                      children: user.interests.map((interest) {
                        return Chip(
                          label: Text(interest),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  UserPictures(user: user),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserPictures extends StatelessWidget {
  final User user;

  const UserPictures({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pictures', style: Theme.of(context).textTheme.titleLarge),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 18),
          height: user.imageUrls.isNotEmpty ? 120 : 0,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: user.imageUrls.length,
            itemBuilder: (context, index) {
              final tag = 'image_$index';
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => OpenFullImage(
                        context: context,
                        imageUrl: user.imageUrls[index],
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
                      url: user.imageUrls[index],
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
  }
}
