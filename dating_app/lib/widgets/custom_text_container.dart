import 'package:flutter/material.dart';

// class CustomTextContainer extends StatelessWidget {

//   final String text;

//   const CustomTextContainer({
//     Key? key,

//     required this.text,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 10, right: 5),
//       child: Container(
//         height: 30,
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(5),
//           gradient: LinearGradient(
//             colors: [
//               Theme.of(context).primaryColor,
//               Theme.of(context).primaryColor,
//             ],
//           ),
//         ),
//         child: Center(
//           child: Text(
//             text,
//             style: Theme.of(context)
//                 .textTheme
//                 .headlineSmall!
//                 .copyWith(color: Colors.white),
//           ),
//         ),
//       ),
//     );
//   }
// }

class CustomTextContainer extends StatelessWidget {
  final String text;
  final double width;

  CustomTextContainer({required this.text, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }
}

