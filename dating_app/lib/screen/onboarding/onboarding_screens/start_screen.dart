import 'package:dating_app/screen/onboarding/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Start extends StatelessWidget {
  final TabController tabController;

  const Start({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 300,
            width: 300,
            child: SvgPicture.asset('assets/threefriends.svg'),
          ),
          
          Text(
            'Welcome To \nF-R-I-E-N-D-S',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                'The correct answer to any question must be based on something that was written in the text or heard in the audio recording.The correct answer to any question must be based on something that was written in the text or heard in the audio recording.',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(height: 1.5),
              ),
            ),
          ),
          SizedBox(height: 10),
          CustomButtom(tabController: tabController, text: 'START'),
        ],
      ),
    );
  }
}
