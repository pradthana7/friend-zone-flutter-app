import 'package:dating_app/blocs/blocs.dart';
import 'package:dating_app/repositories/storage/storage_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CustomImageContainer extends StatelessWidget {
  const CustomImageContainer({
    Key? key,
    this.imageUrl,
  }) : super(key: key);

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, right: 10.0),
      child: Container(
        height: 150,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border(
            bottom: BorderSide(color: Theme.of(context).primaryColor, width: 1),
            top: BorderSide(color: Theme.of(context).primaryColor, width: 1),
            left: BorderSide(color: Theme.of(context).primaryColor, width: 1),
            right: BorderSide(color: Theme.of(context).primaryColor, width: 1),
          ),
        ),
        child: (imageUrl == null)
            ? Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: Icon(
                    Icons.add_circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () async {
                    ImagePicker picker = ImagePicker();
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.gallery);

                    if (image == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('No image was selected'),
                        ),
                      );
                    }

                    if (image != null) {
                      // print('Uploading...');
                      context
                          .read<OnboardingBloc>()
                          .add(UpdateUserImages(image: image));
                    }
                  },
                ),
              )
            : Image.network(imageUrl!, fit: BoxFit.cover),
      ),
    );
  }
}
