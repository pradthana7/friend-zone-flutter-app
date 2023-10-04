import 'package:dating_app/screen/matches/matches_screen.dart';
import 'package:dating_app/screen/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool hasActions;
  final List<IconData> actioinsIcons;
  final List<String> actionsRoutes;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.hasActions = true,
    this.actioinsIcons = const [Icons.chat_bubble_outline_rounded, Icons.person_pin_outlined],
    this.actionsRoutes = const [
      MatchesScreen.routeName,
      ProfileScreen.routeName,
    ],
    this.bottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.popAndPushNamed(context, '/');
              },
              child: Container(
                child: Image.asset(
                  'assets/logo.png',
                  alignment: Alignment.topCenter,
                  height: 30,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
          )
        ],
      ),
      actions: hasActions
          ? [
              IconButton(
                icon: Icon(
                  actioinsIcons[0],
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, actionsRoutes[0]);
                },
              ),
              IconButton(
                icon: Icon(
                  actioinsIcons[1],
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, actionsRoutes[1]);
                },
              ),
            ]
          : null,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
