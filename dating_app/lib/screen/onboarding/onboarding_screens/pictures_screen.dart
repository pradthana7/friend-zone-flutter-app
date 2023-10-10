import 'package:dating_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../screens.dart';
import '/blocs/blocs.dart';
import '/screen/onboarding/widgets/widgets.dart';

class Pictures extends StatefulWidget {
  const Pictures({
    Key? key,
    required this.state,
  }) : super(key: key);

  final OnboardingLoaded state;

  @override
  _PicturesState createState() => _PicturesState();
}

class _PicturesState extends State<Pictures> {
  bool isImageSelected = false; // Keep track of image selection

  @override
  Widget build(BuildContext context) {
    var images = widget.state.user.imageUrls;
    var imageCount = images.length;
    return OnboardingScreenLayout(
      currentStep: 4,
      onPressed: isImageSelected // Disable button if no image is selected
          ? () {
              context
                  .read<OnboardingBloc>()
                  .add(ContinueOnboarding(user: widget.state.user));
            }
          : null, // Set to null to disable the button

      children: [
        CustomTextHeader(text: 'Add  Picture(s)'),
        SizedBox(height: 20),
        SizedBox(
          height: 550,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.7,
            ),
            itemCount: 9,
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
                            content: Text('No picture was selected'),
                          ),
                        );
                      } else {
                        print('Uploading ...');
                        BlocProvider.of<OnboardingBloc>(context).add(
                          UpdateUserImages(image: image),
                        );
                        setState(() {
                          isImageSelected =
                              true; // Update the image selection status
                        });
                      }
                    });
            },
          ),
        ),
      ],
    );
  }
}
