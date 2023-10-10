import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';
import '../../repositories/repositories.dart';

class SignOut extends StatelessWidget {
  const SignOut({
    Key? key,
  }) : super(key: key);

  static const IconData logout = IconData(0xe3b3, fontFamily: 'MaterialIcons');

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        state as ProfileLoaded;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                _showLogoutDialog(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons
                        .logout, // Assuming you have an "logout" icon available in your icons.
                    size: 24,
                    color: Colors.brown.shade800,
                  ),
                  const SizedBox(width: 4.0),
                  const Text(
                    'Logout',
                    style: TextStyle(
                        color: Colors.brown, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final Color color = Colors.brown.shade800;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Logout Confirmation",
            style: TextStyle(color: color),
          ),
          content: Text(
            "Are you sure you want to log out?",
            style: TextStyle(color: color),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Perform the logout action here
                RepositoryProvider.of<AuthRepository>(context).signOut();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                "Logout",
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
