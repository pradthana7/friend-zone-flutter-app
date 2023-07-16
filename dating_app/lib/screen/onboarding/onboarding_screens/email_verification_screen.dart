import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_text_header.dart';

class EmailVerification extends StatelessWidget {
  final TabController tabController;

  const EmailVerification({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              CustomTextHeader(
                  
                  text: 'Did You Get The Verification Code?'),
              CustomTextField(
                  hint: 'ENTER YOUR CODE'),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              children: [
                StepProgressIndicator(
                  totalSteps: 6,
                  currentStep: 2,
                  selectedColor: Theme.of(context).primaryColor,
                  unselectedColor: Theme.of(context).disabledColor,
                ),
                SizedBox(height: 10),
                CustomButtom(tabController: tabController, text: 'NEXT'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
