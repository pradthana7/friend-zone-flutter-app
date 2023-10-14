import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final String text;
  final bool value;
  final Function(bool?)? onChanged;

  const CustomCheckbox({
    Key? key,
    required this.text,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          
          shape: const CircleBorder(),
          value: value,
          onChanged: onChanged,
          activeColor: Theme.of(context).primaryColor,
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 20),
        )
      ],
    );
  }
}
