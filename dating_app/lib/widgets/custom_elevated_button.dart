import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final double fontSize;
  final Function()? onPressed;
  final double width;

  const CustomElevatedButton(
      {Key? key,
      required this.text,
      required this.textColor,
      required this.onPressed,
      this.width = 150,
      required this.color, required this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withAlpha(50),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(2, 2),
            ),
          ],
          color: color),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Theme.of(context).primaryColor.withAlpha(50),
            elevation: 0,
            fixedSize: Size(width, 40)),
        child: Container(
          width: double.infinity,
          child: Center(
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: textColor, fontSize: fontSize),
            ),
          ),
        ),
      ),
    );
  }
}
