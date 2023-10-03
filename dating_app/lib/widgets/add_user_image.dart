import 'package:flutter/material.dart';

class AddUserImage extends StatelessWidget {
  final void Function()? onPressed;

  const AddUserImage({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10.0,
        right: 10.0,
      ),
      child: Container(
        height: 150,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
            width: 1,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        child: Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: Icon(
              Icons.add_a_photo_rounded,
              color: Theme.of(context).primaryColorDark,
            ),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}