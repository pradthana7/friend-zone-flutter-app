import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class LargeImage extends StatelessWidget {
  static const String routeName = '/largeimage';

  final List<String> imageUrls; // Add imageUrls property

  LargeImage({required this.imageUrls}); // Constructor to receive imageUrls

  @override
  Widget build(BuildContext context) {
    final controller = StoryController(); // Create a StoryController

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Friend Zone'),
      // ),
      backgroundColor: Color.fromARGB(255, 213, 212, 209),
      body: Padding(
        padding: const EdgeInsets.only(top:0, bottom: 0, right: 0, left: 0),
        child: StoryView(
          controller: controller, // Assign the controller to StoryView
          indicatorColor: Colors.brown[200],
          
          storyItems: imageUrls.map((url) {
            return StoryItem.pageImage(url: url, controller: controller);
            
          }).toList(),
          
          onStoryShow: (s) {
            // Handle when a story is shown
          },
          onComplete: () {
            // Handle when all stories are completed
            Navigator.pop(context);
          },
          onVerticalSwipeComplete: (direction) {
            if (direction == Direction.down) {
              // Handle when swiped down (e.g., exit the story view)
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }
}
