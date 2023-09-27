import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hint;
  final String? initialValue;
  final Function(String)? onChanged;
  final Function(bool)? onFocusChanged;
  final EdgeInsets padding;
  final String? errorText;
  final int? maxLines;

  const CustomTextField({
    Key? key,
    this.hint = '',
    this.initialValue = '',
    this.onChanged,
    this.onFocusChanged,
    this.padding = const EdgeInsets.symmetric(horizontal: 20.0),
    this.errorText,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Focus(
        onFocusChange: onFocusChanged ?? (hasFocus) {},
        child: TextFormField(
          initialValue: initialValue,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.blue[50],
            hintText: hint,
            errorText: errorText,
            contentPadding: const EdgeInsets.only(bottom: 5.0, top: 12.5),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.cyan.shade500),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
