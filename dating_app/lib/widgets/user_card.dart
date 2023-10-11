import 'package:dating_app/widgets/user_image.dart';
import 'package:flutter/material.dart';

import '/models/models.dart';
import '/widgets/widgets.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'user_card',
      child: Padding(
        padding: const EdgeInsets.only(top: 14.0, left: 25, right: 25),
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 1.3,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              UserImage.large(url: user.imageUrls[0]),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(200, 0, 0, 0),
                      Color.fromARGB(0, 0, 0, 0)
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              Positioned(
                bottom: 30,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user.name} ${user.age}',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: Colors.white),
                    ),
                    Text(
                      user.jobTitle,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 70,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: user.imageUrls.length + 1,
                          itemBuilder: (builder, index) {
                            return (index < user.imageUrls.length)
                                ? UserImage.small(
                                    url: user.imageUrls[index],
                                    margin:
                                        const EdgeInsets.only(top: 8, right: 8),
                                  )
                                : Container();
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


