import 'package:dating_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class OpenFullImage extends StatelessWidget {
  final BuildContext context;
  final String imageUrl;
  final String tag;

  const OpenFullImage({
    Key? key,
    required this.context,
    required this.imageUrl,
    required this.tag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Hero(
          tag: tag,
          child: UserImage.large(
            url: imageUrl,
          ),
        ),
      ),
    );
  }
}
