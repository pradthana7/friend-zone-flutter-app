import 'package:flutter/material.dart';

class DotStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const DotStepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        // Determine the color of the dot based on the current step
        Color dotColor = index == currentStep
            ? Theme.of(context).primaryColorLight // Active step
            : index < currentStep
                ? Theme.of(context).primaryColor // Completed step
                : Theme.of(context).primaryColorLight; // Inactive step

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 10.0, // Adjust the size as needed
            height: 10.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: dotColor,
            ),
          ),
        );
      }),
    );
  }
}
