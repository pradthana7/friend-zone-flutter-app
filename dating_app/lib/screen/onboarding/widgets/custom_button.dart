import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  

  const CustomButton({
    Key? key,
    required this.text, this.onPressed,
    
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          
          color: Theme.of(context).primaryColor),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        child: SizedBox(
          width: 150,
          child: Center(
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
