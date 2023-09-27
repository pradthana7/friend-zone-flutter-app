import 'package:flutter/material.dart';

class CustomTextContainer extends StatelessWidget {
  final String text;
  final double width;

  CustomTextContainer({required this.text, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }
}
