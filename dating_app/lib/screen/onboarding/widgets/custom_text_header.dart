import 'package:flutter/material.dart';

class CustomTextHeader extends StatelessWidget {
  
  final String text;

  const CustomTextHeader({
    Key? key,
    
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .titleLarge!
          .copyWith(fontWeight: FontWeight.normal),
    );
  }
}
