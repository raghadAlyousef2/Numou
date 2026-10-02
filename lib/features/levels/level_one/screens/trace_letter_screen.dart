// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';
// import '../../../../utiles/Widgets/arabic_progress_bar.dart';
// import '../controllers/level_one_controller.dart';
//
// class TraceLetterScreen extends StatelessWidget {
//   final controller = Get.put(LevelOneController());
//
//   TraceLetterScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(kToolbarHeight), // Extra space if needed
//         child: Container(
//           padding: EdgeInsets.symmetric(
//             horizontal: size.width * 0.05,
//             vertical: size.height * 0.001,
//           ),
//           // Padding for whole AppBar
//           decoration: BoxDecoration(
//             color: Colors.white,
//             border: Border(
//               bottom: BorderSide(
//                 color: Colors.orange,
//                 width: 1,
//               ), // Lower border
//             ),
//           ),
//           child: AppBar(
//             backgroundColor: Colors.transparent,
//             // Make AppBar transparent to show container color
//             elevation: 0,
//             // Remove shadow
//             leadingWidth: size.width * 0.4,
//             automaticallyImplyLeading: false,
//
//             leading: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 IconButton(
//                   onPressed: () => print("Button 1"),
//                   icon: Image.asset(
//                     'assets/images/app_bar_home.png',
//                     width: size.width * 0.05,
//                     height: size.height * 0.05,
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () => print("Button 2"),
//                   icon: Image.asset(
//                     'assets/images/app_bar_profile.png',
//                     width: size.width * 0.05,
//                     height: size.height * 0.05,
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () => print("Button 3"),
//                   icon: Image.asset(
//                     'assets/images/app_bar_badge.png',
//                     width: size.width * 0.05,
//                     height: size.height * 0.05,
//                   ),
//                 ),
//               ],
//             ),
//             actions: [
//               IconButton(
//                 onPressed: () => print("Button 4"),
//                 icon: Image.asset(
//                   'assets/images/app_bar_logout.png',
//                   width: size.width * 0.05,
//                   height: size.height * 0.05,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(right: 8),
//                 child: Image.asset(
//                   'assets/images/numou_logo.png',
//                   width: size.width * 0.07,
//                   height: size.height * 0.07,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//
//       body: SafeArea(
//         child: Stack(
//           children: [
//             // Background image
//             Positioned.fill(
//               child: Image.asset(
//                 'assets/images/home_screen_background.png',
//                 fit: BoxFit.fill,
//               ),
//             ),
//
//             Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: size.width * 0.02,
//                     vertical: size.height * 0.01,
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       ArabicProgressBar(
//                         progressValue: 0.3,
//                         levelText: 'ready.level.beginner',
//                       ),
//                       Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(
//                             size.width * 0.07,
//                           ),
//                           color: Colors.white,
//                           border: Border.all(color: Colors.grey, width: 1),
//                         ),
//
//                         child: IconButton(
//                           onPressed: () {
//                             Get.back();
//                           },
//                           icon: Icon(
//                             Icons.arrow_forward,
//                             color: Colors.black,
//                             size: size.width * 0.07,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: size.height * 0.05),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 48.0),
//                   child: Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(15),
//                       border: Border.all(color: Colors.white, width: 2),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey, // Shadow color
//                           spreadRadius: 0.0,
//                           blurRadius: 2,
//                           offset: Offset(0, 5), // Only bottom shadow
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Image.asset(
//                           'assets/images/level_one_letter_alif.png',
//                           height: size.height * 0.2,
//                           width: size.width * 0.4,
//                         ),
//
//                         Image.asset(
//                           'assets/images/level_one_character_1.png',
//                           height: size.height * 0.2,
//                           width: size.width * 0.8,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//
//
//                   children: [
//                     // Left side: Text note and speaker button
//                     SizedBox(
//                       width: size.width * 0.4,
//                       height: size.height * 0.3,
//                       //padding: const EdgeInsets.all(8),
//                       // margin: const EdgeInsets.all(8),
//
//                       child: Transform(
//                         alignment: Alignment.center,
//                         transform: Matrix4.rotationY(pi),
//                         child: Lottie.asset(
//                           'assets/characters/cute_tiger.json',
//
//                           fit: BoxFit.fill,
//                           controller: controller.lottieController,
//                           onLoaded: (composition) {
//                             controller.lottieController.duration =
//                                 composition.duration ;
//                           },
//                         ),
//                       ),
//                     ),
//
//
//                     Obx(
//                           () => Container(
//                         width: size.width * 0.4,
//                         height: size.height * 0.15,
//                         padding: const EdgeInsets.all(8),
//
//                         decoration: BoxDecoration(
//                           color: Colors.greenAccent.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(15),
//                           border: Border.all(color: Colors.green, width: 2),
//                         ),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//
//                               controller.noteText.value,
//                               style:  TextStyle(
//                                 fontSize: size.width*0.04,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black87,
//
//                               ),
//                               textAlign: TextAlign.right,
//                             ),
//                             // const SizedBox(height: 20),
//                             IconButton(
//                               icon: const Icon(
//                                 Icons.volume_up,
//                                 size: 36,
//                                 color: Colors.green,
//                               ),
//                               onPressed: controller.startPronounceSequence,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//
//                     // Right side: Tiger animation
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
