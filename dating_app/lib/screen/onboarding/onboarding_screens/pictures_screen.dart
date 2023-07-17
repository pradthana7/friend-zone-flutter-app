import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import '/blocs/blocs.dart';
import '/screen/onboarding/widgets/widgets.dart';

class Pictures extends StatelessWidget {
  const Pictures({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        if (state is OnboardingLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is OnboardingLoaded) {
          var images = state.user.imageUrls;
          var imageCount = images.length;
          return SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextHeader(text: 'Add 2 or More Pictures'),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 400,
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.66,
                          ),
                          itemCount: 6,
                          itemBuilder: (BuildContext context, int index) {
                            return (imageCount > index)
                                ? CustomImageContainer(imageUrl: images[index])
                                : CustomImageContainer();
                          },
                        ),
                      ),
                      SizedBox(height: 100)
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        StepProgressIndicator(
                          totalSteps: 6,
                          currentStep: 4,
                          selectedColor: Theme.of(context).primaryColor,
                          unselectedColor: Theme.of(context).backgroundColor,
                        ),
                        SizedBox(height: 10),
                        CustomButton(
                          text: 'NEXT',
                          onPressed: () {
                            context
                                .read<OnboardingBloc>()
                                .add(ContinueOnboarding(user: state.user));
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Text('Something went wrong.');
        }
      },
    );
  }
}
