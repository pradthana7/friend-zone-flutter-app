import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final Color beginColor;
  final Color endColor;
  final Color textColor;
  final Function()? onPressed;
  final double width;

  const CustomElevatedButton(
      {Key? key,
      required this.text,
      required this.beginColor,
      required this.endColor,
      required this.textColor,
      required this.onPressed,
      this.width = 200})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withAlpha(50),
            spreadRadius: 2,
            blurRadius: 2,
            offset: Offset(2, 2),
          ),
        ],
        gradient: LinearGradient(
          colors: [beginColor, endColor],
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            elevation: 0,
            fixedSize:  Size(width, 40)),
        child: Container(
          width: double.infinity,
          child: Center(
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}
