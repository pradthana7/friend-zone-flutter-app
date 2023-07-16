import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool hasActions;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.hasActions = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(children: [
        Expanded(
          child: SvgPicture.asset(
            'assets/newlogo.svg',
            height: 50,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline6,
          ),
        )
      ]),
      actions: hasActions
          ? [
              IconButton(
                icon: Icon(Icons.messenger_outline_rounded,
                    color: Theme.of(context).primaryColor),
                onPressed: () {
                  Navigator.pushNamed(context, '/matches');
                },
              ),
              IconButton(
                icon: Icon(Icons.person_outline_outlined,
                    color: Theme.of(context).primaryColor),
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
              )
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
