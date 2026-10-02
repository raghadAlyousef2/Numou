import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:numou/features/authentication/controllers/auth_controller.dart';
import 'package:numou/features/dashbaord/screens/character_select_screen.dart';
import 'package:numou/features/dashbaord/screens/widgets/skill_badges.dart';

import '../../../Controllers/namou_firebase_data_controller.dart';
import '../../../Models/characters.dart';
import '../../../utiles/Constant/helper_funciton.dart';
import '../../../utiles/Widgets/arabic_progress_bar.dart';
import '../../../utiles/Widgets/gray_scale_widget.dart';
import '../../map/screens/map_screen.dart';
import '../controllers/home_screen_controller.dart';
import '../../levels/level_one/screens/level_one_screen.dart';
import 'child_dashboard.dart';

class HomeScreen extends StatelessWidget {
  final HomeScreenController controller = Get.put(
    HomeScreenController(),
    permanent: false,
  );
  final authController = Get.find<AuthController>();
  final data = Get.find<NamouFirebaseDataController>();


  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return PopScope<void>(
      // Block the automatic pop (hardware back / iOS swipe)
      canPop: false,

      // NEW API (use this, onPopInvoked is deprecated)
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return; // Someone already popped the route; do nothing.



        if (context.mounted) {
          controller.stopMedia();
          Get.back(); // or: Navigator.of(context).pop();

        }
      }, child:  Obx(
          ()=> GrayscaleWidget(
        isGrayscale: !data.isOnline.value,
        isAbsorb: false,

        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight), // Extra space if needed
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
                vertical: size.height * 0.001,
              ),
              // Padding for whole AppBar
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.orange,
                    width: 1,
                  ), // Lower border
                ),
              ),
              child: AppBar(
                backgroundColor: Colors.transparent,
                // Make AppBar transparent to show container color
                elevation: 0,
                // Remove shadow
                leadingWidth: size.width * 0.4,
                automaticallyImplyLeading: false,

                leading: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        controller.stopMedia();
                        Get.back();},
                      icon: Image.asset(
                        'assets/images/app_bar_home.png',
                        width: size.width * 0.05,
                        height: size.height * 0.05,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.stopMedia();
                        Get.to(() => const ChildDashboardScreen());}
                      ,
                      icon: Image.asset(
                        controller.currentChildAvatarAsset,
                        width: size.width * 0.05,
                        height: size.height * 0.05,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.stopMedia();
                        Get.to(()=> CharacterSelectScreen());
                      },
                        icon: Icon(Icons.accessibility, size: size.width * 0.06,color: Colors.orange, ),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    onPressed: () => authController.logOut(),
                    icon: Image.asset(
                      'assets/images/app_bar_logout.png',
                      width: size.width * 0.05,
                      height: size.height * 0.05,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Image.asset(
                      'assets/images/numou_logo.png',
                      width: size.width * 0.07,
                      height: size.height * 0.07,
                    ),
                  ),
                ],
              ),
            ),
          ),

          body: SafeArea(
            child: Stack(
              children: [
                // Background image
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/home_screen_background.png',
                    fit: BoxFit.fill,
                  ),
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.02,
                        vertical: size.height * 0.01,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Obx(() {
                            final pts   = data.selectedChildPoints;       // earned so far
                            final total = data.totalPossiblePoints;       // 112
                            final prog  = data.selectedChildProgress01;   // 0..1

                            // If your ArabicProgressBar just shows a single text,
                            // embed the numbers in Arabic-friendly text:
                            final label = titleForPoints(pts, total); // or 'progress.total'.tr + ' $pts/$total'

                            return Column(
                              children: [
                                // SizedBox(height: size.height*0.01,),
                                SkillBadges(current: label),
                                SizedBox(height: size.height*0.005,),
                                ArabicProgressBar(
                                  progressValue: prog,   // 0..1
                                  levelText: label,
                                  points: pts,// Arabic label with numbers
                                ),
                              ],
                            );
                          }),
                          SizedBox(width: size.width*0.02,),

                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                size.width * 0.07,
                              ),
                              color: Colors.white,
                              border: Border.all(color: Colors.grey, width: 1),
                            ),

                            child: IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(
                                Icons.arrow_forward,
                                size: size.width * 0.07,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48.0),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey, // Shadow color
                              spreadRadius: 0.0,
                              blurRadius: 2,
                              offset: Offset(0, 5), // Only bottom shadow
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Obx(() {
                              final data = Get.find<NamouFirebaseDataController>();
                              final id   = data.selectedChildId.value;
                              final key  = (id == null) ? null : data.children[id]?.character;
                              final preset = (key != null && kCharacterPresets.containsKey(key))
                                  ? kCharacterPresets[key]!
                                  : kCharacterPresets['tom']!; // fallback

                              return SizedBox(
                                width: size.width * 0.4,
                                height: size.height * 0.28,
                                child: Lottie.asset(
                                  preset.lottieAsset,
                                  controller: controller.lottieController,
                                  fit: BoxFit.fill,
                                  onLoaded: (comp) {
                                    controller.lottieController.duration = comp.duration
                                    ;
                                  },
                                ),
                              );
                            }),
                            // Image.asset(
                            //   'assets/images/home_screen_character_1.png',
                            //   height: size.height * 0.24,
                            //   width: size.width * 0.34,
                            //   fit: BoxFit.fill,
                            // ),
                            Obx(
                              () => Text(
                                controller.helloText.value,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: size.width * 0.050,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: size.height * 0.02),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    // Background color of the button
                                    borderRadius: BorderRadius.circular(12),
                                    // border: Border.all(
                                    //   color: Color(0xFFE5E5E5), // Border color
                                    //   width: 2, // Border thickness
                                    // ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFF58A700), // Shadow color
                                        spreadRadius: 0.0,
                                        blurRadius: 0.0,
                                        offset: Offset(0, 4), // Only bottom shadow
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // go to lesson
                                      controller.stopMedia();
                                      Get.to(() => MapScreen());
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF58CC02),
                                      padding: EdgeInsets.symmetric(
                                        vertical: size.height * 0.01,
                                        horizontal: size.width * 0.04,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Directionality(
                                          textDirection: TextDirection.ltr,
                                          child: Icon(
                                            Icons.arrow_forward,
                                            color: Color(0xFFFFFFFF),
                                          ),
                                        ),
                                        SizedBox(width: size.width * 0.02),
                                        Text(
                                          'ready.yes'.tr,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: size.width * 0.038,
                                            color: Color(0xFFFFFFFF),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(width: size.width * 0.00),

                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    // Background color of the button
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Color(0xFFE5E5E5),
                                      // Border color
                                      width: 2, // Border thickness
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFFE5E5E5),
                                        // Shadow color
                                        spreadRadius: 0.1,
                                        blurRadius: 0.1,
                                        offset: Offset(0, 1), // Only bottom shadow
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      controller.stopMedia();
                                      Get.back();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      // Make transparent to show Container color
                                      shadowColor: Colors.transparent,
                                      // Disable default shadow
                                      padding: EdgeInsets.symmetric(
                                        vertical: size.height * 0.01,
                                        horizontal: size.width * 0.06,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      'ready.no'.tr,
                                      style: TextStyle(
                                        fontSize: size.width * 0.038,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF1CB0F6),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: size.width * 0.25),
                          Image.asset(
                            'assets/images/home_screen_image_1.png',
                            height: size.height * 0.25,
                            width: size.width * 0.45,
                            fit: BoxFit.fill,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}
