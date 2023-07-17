import 'package:dating_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import '../../screens.dart';
import '/blocs/blocs.dart';
import '/screen/onboarding/widgets/widgets.dart';

class Pictures extends StatelessWidget {
  const Pictures({
    Key? key,
    required this.state,
  }) : super(key: key);

  final OnboardingLoaded state;

  @override
  Widget build(BuildContext context) {
    var images = state.user.imageUrls;
    var imageCount = images.length;
    return OnboardingScreenLayout(
      currentStep: 4,
      onPressed: () {
        context
            .read<OnboardingBloc>()
            .add(ContinueOnboarding(user: state.user));
      },
      children: [
        CustomTextHeader(text: 'Add 2 or More Pictures'),
        SizedBox(height: 20),
        SizedBox(
          height: 400,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.66,
            ),
            itemCount: 6,
            itemBuilder: (BuildContext context, int index) {
              return (imageCount > index)
                  ? UserImage.medium(
                      url: images[index],
                      border: Border.all(
                        width: 1,
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : AddUserImage(onPressed: () async {
                      final XFile? image = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 50,
                      );

                      if (image == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('No image was selected'),
                          ),
                        );
                      } else {
                        print('Uploading ...');
                        BlocProvider.of<OnboardingBloc>(context).add(
                          UpdateUserImages(image: image),
                        );
                      }
                    });
            },
          ),
        ),
      ],
    );
    //  Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     mainAxisSize: MainAxisSize.max,
    //     children: [
    //       Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [

    //           SizedBox(height: 100)
    //         ],
    //       ),
    //       Align(
    //         alignment: Alignment.bottomCenter,
    //         child: Column(
    //           children: [
    //             StepProgressIndicator(
    //               totalSteps: 6,
    //               currentStep: 4,
    //               selectedColor: Theme.of(context).primaryColor,
    //               unselectedColor: Theme.of(context).backgroundColor,
    //             ),
    //             SizedBox(height: 10),
    //             CustomButton(
    //               text: 'NEXT',
    //               onPressed:

    //             )
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
